import 'package:dartz/dartz.dart';
import 'package:fair_share/features/notifications/domain/entities/notifications_entity.dart';
import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';

class NotifyFlatMembersUseCase {
  final NotificationsRepository repository;

  NotifyFlatMembersUseCase(this.repository);

  Future<void> call({
    required List<String> userIds,
    required NotificationsEntity notification,
  }) {
    return repository.notifyFlatMembers(
      userIds: userIds,
      notification: notification,
    );
  }
}
