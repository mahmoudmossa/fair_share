import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:fair_share/features/notifications/data/models/notifications_dto.dart';

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final FirebaseFirestore _firestore;

  NotificationsRemoteDataSourceImpl(this._firestore);

  final _errorMapper = FirebaseErrorMapper();

  @override
  Future<void> saveFcmToken(String userId, String token) async {
    try {
      final userRef = _firestore.collection(FirestoreConstants.users).doc(userId);
      await userRef.update({
        FirestoreConstants.fcmTokens: FieldValue.arrayUnion([token]),
      });
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
      await userRef.update({
        FirestoreConstants.fcmTokens: FieldValue.arrayRemove([token]),
      });
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
  }
}
