import 'package:fair_share/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:fair_share/features/notifications/data/models/notifications_dto.dart';
import 'package:fair_share/features/notifications/domain/entities/notifications_entity.dart';
import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;

  NotificationsRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> saveFcmToken(String userId, String token) async {
    await _remoteDataSource.saveFcmToken(userId, token);
  }

  @override
  Future<void> removeFcmToken(String userId, String token) async {
    await _remoteDataSource.removeFcmToken(userId, token);
  }

  @override
  Stream<List<NotificationsEntity>> watchNotifications(String userId) {
    return _remoteDataSource
        .watchNotifications(userId)
        .map((dtos) => dtos.map((dto) => dto.toEntity()).toList());
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) async {
    await _remoteDataSource.markAsRead(userId, notificationId);
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await _remoteDataSource.markAllAsRead(userId);
  }

  @override
  Future<void> notifyFlatMembers({
    required List<String> userIds,
    required NotificationsEntity notification,
  }) async {
    final dto = NotificationsDto.fromEntity(notification);
    await _remoteDataSource.notifyFlatMembers(
      userIds: userIds,
      notification: dto,
    );
  }
}
