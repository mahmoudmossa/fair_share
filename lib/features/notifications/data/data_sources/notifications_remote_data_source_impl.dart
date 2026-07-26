import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'package:fair_share/features/notifications/data/models/notifications_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'notifications_remote_data_source.dart';

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final FirebaseFirestore _firestore;

  NotificationsRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> markAllAsRead(String userId) async {}

  @override
  Future<void> markAsRead(String userId, String notificationId) async {
    await _firestore
        .collection(FirestoreConstants.users)
        .doc(userId)
        .collection(FirestoreConstants.notifications)
        .doc(notificationId)
        .update({'isRead': true});
  }

  @override
  Stream<List<NotificationsDto>> watchNotifications(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => NotificationsDto.fromJson(doc.data()))
              .toList(),
        );

    // TODO: Implement data source methods
  }

  @override
  Future<void> notifyFlatMembers({
    required List<String> userIds,
    required NotificationsDto notification,
  }) async {
    final batch = _firestore.batch();
    for (final userId in userIds) {
      final ref = _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .collection(FirestoreConstants.notifications)
          .doc();
      batch.set(ref, notification.toJson());
    }
    await batch.commit();
  }
}
