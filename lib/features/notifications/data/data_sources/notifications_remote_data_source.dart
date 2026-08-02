import 'package:fair_share/features/notifications/data/models/notifications_dto.dart';

abstract class NotificationsRemoteDataSource {
  Future<void> saveFcmToken(String userId, String token);
  Future<void> removeFcmToken(String userId, String token);
  Stream<List<NotificationsDto>> watchNotifications(String userId);
  Future<void> markAsRead(String userId, String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> notifyFlatMembers({
    required List<String> userIds,
    required NotificationsDto notification,
  });
}
