import 'package:fair_share/features/notifications/domain/entities/notifications_entity.dart';
import 'package:fair_share/features/notifications/domain/usecases/notify_flat_members.dart';
import 'package:fair_share/features/notifications/presentation/providers/notifications_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core/shared_core.dart';

part 'notify_members_notifier_provider.g.dart';

@riverpod
class NotifyMembersNotifier extends _$NotifyMembersNotifier {
  @override
  ActionState<void> build() => const ActionState.initial();

  Future<void> notify(
    List<String> userIds,
    NotificationsEntity notification,
  ) async {
    state = const ActionState.loading();
    try {
      final repository = ref.read(notificationsRepositoryProvider);
      final notifyUsecase = NotifyFlatMembersUseCase(repository);
      await notifyUsecase(userIds: userIds, notification: notification);
      state = const ActionState.success(null);
    } catch (e, st) {
      state = ActionState.error(e, st);
    }
  }
}
