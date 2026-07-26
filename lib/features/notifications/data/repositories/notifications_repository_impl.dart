import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/notifications/data/models/notifications_dto.dart';
import 'package:fair_share/features/notifications/domain/entities/notifications_entity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_core/shared_core.dart';

import '../../domain/repositories/notifications_repository.dart';
import '../data_sources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;
  final AppErrorHandler errorHandler;
  final FirebaseErrorMapper firebaseErrorMapper;

  NotificationsRepositoryImpl({
    required this._remoteDataSource,
    required this.errorHandler,
    required this.firebaseErrorMapper,
  });

  @override
  Future<void> markAllAsRead(String userId) {
    // TODO: implement markAllAsRead
    throw UnimplementedError();
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) {
    // TODO: implement markAsRead
    throw UnimplementedError();
  }

  @override
  Future<void> notifyFlatMembers({
    required List<String> userIds,
    required NotificationsEntity notification,
  }) async {
    try {
      await _remoteDataSource.notifyFlatMembers(
        userIds: userIds,
        notification: NotificationsDto.fromEntity(notification),
      );
    } on FirebaseException catch (e, stackTrace) {
      errorHandler.handle(
        e,
        stackTrace,
        context: 'FlatRepositoryImpl.createFlat',
      );
    }
  }

  @override
  Stream<List<NotificationsEntity>> watchNotifications(String userId) {
    // TODO: implement watchNotifications
    throw UnimplementedError();
  }

  // TODO: Implement repository methods delegating to _remoteDataSource
}
