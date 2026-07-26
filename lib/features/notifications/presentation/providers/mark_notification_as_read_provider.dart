import 'package:fair_share/features/notifications/domain/usecases/mark_notification_as_read.dart';
import 'package:fair_share/features/notifications/presentation/providers/notifications_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core/shared_core.dart';

part 'mark_notification_as_read_provider.g.dart';

@riverpod
class MarkNotificationAsRead extends _$MarkNotificationAsRead {
  @override
  ActionState<void> build() => const ActionInitial();

  Future<void> markAsRead({
    required String userId,
    required String notificationId,
  }) async {
    state = const ActionLoading();
    try {
      final repository = ref.read(notificationsRepositoryProvider);
      final useCase = MarkNotificationAsReadUseCase(repository);
      await useCase(userId, notificationId);
      state = const ActionSuccess(null);
    } catch (e) {
      state = ActionError(e);
    }
  }
}
