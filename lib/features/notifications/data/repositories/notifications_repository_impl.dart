import '../../domain/repositories/notifications_repository.dart';
import '../data_sources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl
    implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;

  NotificationsRepositoryImpl(this._remoteDataSource);

  // TODO: Implement repository methods delegating to _remoteDataSource
}
