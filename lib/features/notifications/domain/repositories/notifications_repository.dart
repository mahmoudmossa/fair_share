import 'package:fair_share/features/notifications/domain/entities/notifications_entity.dart';

abstract class NotificationsRepository {
  Future<void> saveFcmToken(String userId, String token);
  Future<void> removeFcmToken(String userId, String token);
  Stream<List<NotificationsEntity>> watchNotifications(String userId);
  Future<void> markAsRead(String userId, String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> notifyFlatMembers({
    required List<String> userIds,
    required NotificationsEntity notification,
  });
}

