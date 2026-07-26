import '../entities/notifications_entity.dart';

abstract class NotificationsRepository {
  Stream<List<NotificationsEntity>> watchNotifications(String userId);
  Future<void> markAsRead(String userId, String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> notifyFlatMembers({
    required List<String> userIds,
    required NotificationsEntity notification,
  });
}
