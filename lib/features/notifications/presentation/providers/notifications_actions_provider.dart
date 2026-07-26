import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core/shared_core.dart';
import 'notifications_repository_provider.dart';

part 'notifications_actions_provider.g.dart';

@riverpod
class NotificationsActions extends _$NotificationsActions {
  @override
  ActionState<void> build() {
    return const ActionInitial();
  }

  // TODO: Add action methods that call repository methods.
  // Example:
  // Future<void> doSomething({required String id}) async {
  //   state = const ActionLoading();
  //   final repository = ref.read(notificationsRepositoryProvider);
  //   final result = await repository.doSomething(id);
  //   state = result.fold(
  //     (error) => ActionError(error),
  //     (_) => const ActionSuccess(null),
  //   );
  // }
}
