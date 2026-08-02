import 'package:fair_share/features/notifications/domain/usecases/mark_all_notification_as_read.dart';
import 'package:fair_share/features/notifications/presentation/providers/notifications_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core/shared_core.dart';

part 'mark_all_notifications_as_read_provider.g.dart';

@riverpod
class MarkAllNotificationsAsRead extends _$MarkAllNotificationsAsRead {
  @override
  ActionState<void> build() => const ActionInitial();

  Future<void> markAllAsRead({required String userId}) async {
    state = const ActionLoading();
    try {
      final repository = ref.read(notificationsRepositoryProvider);
      final useCase = MarkAllNotificationAsReadUseCase(repository);
      await useCase(userId);
      state = const ActionSuccess(null);
    } catch (e) {
      state = ActionError(e);
    }
  }
}
