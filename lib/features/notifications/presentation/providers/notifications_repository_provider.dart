import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../data/repositories/notifications_repository_impl.dart';
import '../../data/data_sources/notifications_remote_data_source_impl.dart';

part 'notifications_repository_provider.g.dart';

@riverpod
NotificationsRepository notificationsRepository(Ref ref) {
  return NotificationsRepositoryImpl(
    ref.watch(notificationsRemoteDataSourceProvider),
  );
}
