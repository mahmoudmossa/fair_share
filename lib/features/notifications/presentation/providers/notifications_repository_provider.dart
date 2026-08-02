import 'package:fair_share/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:fair_share/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:fair_share/features/notifications/presentation/providers/notifications_remote_data_source_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_repository_provider.g.dart';

@riverpod
NotificationsRepository notificationsRepository(Ref ref) {
  final remoteDataSource = ref.watch(notificationsRemoteDataSourceProvider);
  return NotificationsRepositoryImpl(remoteDataSource);
}
