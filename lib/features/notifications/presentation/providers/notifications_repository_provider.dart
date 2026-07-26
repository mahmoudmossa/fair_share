import 'package:fair_share/core/providers/app_error_handler_provider.dart';
import 'package:fair_share/core/providers/firebase_error_mapper_provider.dart';
import 'package:fair_share/features/notifications/presentation/providers/notifications_data_source_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../data/repositories/notifications_repository_impl.dart';

part 'notifications_repository_provider.g.dart';

@riverpod
NotificationsRepository notificationsRepository(Ref ref) {
  return NotificationsRepositoryImpl(
    remoteDataSource: ref.watch(notificationsRemoteDataSourceProvider),
    errorHandler: ref.watch(appErrorHandlerProvider),
    firebaseErrorMapper: ref.watch(firebaseErrorMapperProvider),
  );
}
