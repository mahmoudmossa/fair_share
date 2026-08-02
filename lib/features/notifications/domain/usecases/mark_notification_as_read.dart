import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';

class MarkNotificationAsReadUseCase {
  final NotificationsRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<void> call(String userId, String notificationId) {
    return repository.markAsRead(userId, notificationId);
  }
}
