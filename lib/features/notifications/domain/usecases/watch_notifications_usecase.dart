import 'package:fair_share/features/notifications/domain/entities/notifications_entity.dart';
import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';

class WatchNotificationsUseCase {
  final NotificationsRepository _repository;

  WatchNotificationsUseCase(this._repository);

  Stream<List<NotificationsEntity>> call(String userId) {
    return _repository.watchNotifications(userId);
  }
}
