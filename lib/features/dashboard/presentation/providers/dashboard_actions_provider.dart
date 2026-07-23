import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import 'dashboard_repository_provider.dart';

part 'dashboard_actions_provider.g.dart';

@riverpod
class DashboardActions extends _$DashboardActions {
  @override
  ActionState<void> build() {
    return const ActionInitial();
  }

  Future<void> createFlat(String name) async {
    state = const ActionLoading();
    final auth = ref.read(authStateProvider).value;
    if (auth == null) {
      state = ActionError(Exception('User not authenticated'));
      return;
    }

    final repository = ref.read(dashboardRepositoryProvider);
    final result = await repository.createFlat(
      name,
      auth.id,
      auth.displayName ?? auth.email.split('@').first,
    );
    state = result.fold(
      (error) => ActionError(error),
      (flatId) => const ActionSuccess(null),
    );
  }

  Future<void> joinFlat(String invitationCode) async {
    state = const ActionLoading();
    final auth = ref.read(authStateProvider).value;
    if (auth == null) {
      state = ActionError(Exception('User not authenticated'));
      return;
    }

    final repository = ref.read(dashboardRepositoryProvider);
    final result = await repository.joinFlat(
      invitationCode.trim(),
      auth.id,
      auth.displayName ?? auth.email.split('@').first,
    );

    state = result.fold(
      (error) => ActionError(error),
      (success) {
        if (success) {
          return const ActionSuccess(null);
        } else {
          return ActionError(Exception('Invalid invitation code'));
        }
      },
    );
  }

  Future<void> addExpense({
    required String flatId,
    required String title,
    required double amount,
    required String category,
  }) async {
    state = const ActionLoading();
    final auth = ref.read(authStateProvider).value;
    if (auth == null) {
      state = ActionError(Exception('User not authenticated'));
      return;
    }

    final repository = ref.read(dashboardRepositoryProvider);
    final result = await repository.addExpense(
      flatId,
      title,
      amount,
      auth.id,
      auth.displayName ?? auth.email.split('@').first,
      category,
    );

    state = result.fold(
      (error) => ActionError(error),
      (_) => const ActionSuccess(null),
    );
  }

  Future<void> settleDebt({
    required String flatId,
    required String debtId,
  }) async {
    state = const ActionLoading();
    final auth = ref.read(authStateProvider).value;
    if (auth == null) {
      state = ActionError(Exception('User not authenticated'));
      return;
    }

    final repository = ref.read(dashboardRepositoryProvider);
    final result = await repository.settleDebt(
      flatId,
      debtId,
      auth.id,
      auth.displayName ?? auth.email.split('@').first,
    );

    state = result.fold(
      (error) => ActionError(error),
      (_) => const ActionSuccess(null),
    );
  }
}
