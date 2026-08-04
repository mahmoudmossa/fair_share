import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/config/env_config.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:fair_share/features/notifications/data/models/notifications_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final FirebaseFirestore _firestore;

  NotificationsRemoteDataSourceImpl(this._firestore);

  final _errorMapper = FirebaseErrorMapper();

  @override
  Future<void> saveFcmToken(String userId, String token) async {
    try {
      final userRef = _firestore.collection(FirestoreConstants.users).doc(userId);
      await userRef.set(
        {FirestoreConstants.fcmTokens: FieldValue.arrayUnion([token])},
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw _errorMapper.mapException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFcmToken(String userId, String token) async {
    try {
      final userRef = _firestore.collection(FirestoreConstants.users).doc(userId);
      await userRef.set(
        {FirestoreConstants.fcmTokens: FieldValue.arrayRemove([token])},
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw _errorMapper.mapException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<NotificationsDto>> watchNotifications(String userId) {
    return _firestore
        .collection(FirestoreConstants.users)
        .doc(userId)
        .collection(FirestoreConstants.notifications)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationsDto.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .collection(FirestoreConstants.notifications)
          .doc(notificationId)
          .update({'isRead': true});
    } on FirebaseException catch (e) {
      throw _errorMapper.mapException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final snapshot = await _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .collection(FirestoreConstants.notifications)
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      throw _errorMapper.mapException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> notifyFlatMembers({
    required List<String> userIds,
    required NotificationsDto notification,
  }) async {
    // 1. Write in-app notification docs to Firestore (bell icon)
    try {
      final batch = _firestore.batch();

      for (final userId in userIds) {
        final docRef = _firestore
            .collection(FirestoreConstants.users)
            .doc(userId)
            .collection(FirestoreConstants.notifications)
            .doc(notification.id);
        batch.set(docRef, notification.toJson());
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      throw _errorMapper.mapException(e);
    } catch (e) {
      rethrow;
    }

    // 2. Send FCM push notifications via Vercel relay (background / closed app)
    //    This is fire-and-forget — a push failure should never block the main flow.
    unawaited(_sendPushViaVercel(userIds: userIds, notification: notification));
  }

  /// Collects FCM tokens for each recipient from Firestore, then calls the
  /// Vercel serverless relay to deliver the FCM push notification.
  Future<void> _sendPushViaVercel({
    required List<String> userIds,
    required NotificationsDto notification,
  }) async {
    final apiUrl = EnvConfig.pushApiUrl;
    final apiSecret = EnvConfig.pushApiSecret;

    // Skip silently if env vars are not configured (e.g. during development
    // without the --dart-define flags, or when running on emulators).
    if (apiUrl.isEmpty || apiSecret.isEmpty) {
      debugPrint('⚠️ Push API not configured — skipping FCM push (set PUSH_API_URL & PUSH_API_SECRET)');
      return;
    }

    try {
      // Collect all FCM tokens from each user's Firestore document
      final tokenFutures = userIds.map((uid) =>
        _firestore.collection(FirestoreConstants.users).doc(uid).get(),
      );
      final userDocs = await Future.wait(tokenFutures);

      final allTokens = <String>[];
      for (final doc in userDocs) {
        final tokens = List<String>.from(doc.data()?[FirestoreConstants.fcmTokens] ?? []);
        allTokens.addAll(tokens);
      }

      if (allTokens.isEmpty) {
        debugPrint('ℹ️ No FCM tokens found for recipients — skipping push');
        return;
      }

      // Call the Vercel relay endpoint
      final response = await http.post(
        Uri.parse('$apiUrl/api/send-notification'),
        headers: {
          'Content-Type': 'application/json',
          'x-fairshare-secret': apiSecret,
        },
        body: jsonEncode({
          'tokens': allTokens,
          'title': notification.title,
          'body': notification.body,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('✅ FCM push sent. Sent: ${body['sent']}, Stale tokens: ${body['staleTokens']}');

        // Remove any stale tokens that FCM rejected
        final staleTokens = List<String>.from(body['staleTokens'] ?? []);
        if (staleTokens.isNotEmpty) {
          await _removeStaleTokens(staleTokens, userIds);
        }
      } else {
        debugPrint('❌ Push relay returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      // Non-fatal — in-app notification was already written successfully
      debugPrint('❌ Failed to send FCM push via Vercel: $e');
    }
  }

  /// Removes stale FCM tokens from all user documents in Firestore.
  Future<void> _removeStaleTokens(List<String> staleTokens, List<String> userIds) async {
    final batch = _firestore.batch();
    for (final uid in userIds) {
      final userRef = _firestore.collection(FirestoreConstants.users).doc(uid);
      batch.update(userRef, {
        FirestoreConstants.fcmTokens: FieldValue.arrayRemove(staleTokens),
      });
    }
    await batch.commit();
  }
}
