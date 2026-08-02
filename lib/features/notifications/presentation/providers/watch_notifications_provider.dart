import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import 'package:fair_share/features/notifications/domain/entities/notifications_entity.dart';
import 'package:fair_share/features/notifications/domain/usecases/watch_notifications_usecase.dart';
import 'package:fair_share/features/notifications/presentation/providers/notifications_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'watch_notifications_provider.g.dart';

@riverpod
Future<Stream<List<NotificationsEntity>>> build(Ref ref) async {
  final authState = await ref.watch(authStateProvider.future);
  if (authState == null) return Stream.value([]);
  final repository = ref.watch(notificationsRepositoryProvider);
  final watchNotificationUsecase = WatchNotificationsUseCase(repository);
  return watchNotificationUsecase(authState.id);
}
