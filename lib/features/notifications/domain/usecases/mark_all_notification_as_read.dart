import 'package:dartz/dartz.dart';
import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';

class MarkAllNotificationAsReadUseCase {
  final NotificationsRepository repository;

  MarkAllNotificationAsReadUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.markAllAsRead(userId);
  }
}
