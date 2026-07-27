import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/features/new_flat/domain/entities/recurrence_type.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import '../../domain/entities/expense_entity.dart';
import 'add_new_expense_use_case_provider.dart';
import '../../domain/use_cases/settle_use_case.dart';

part 'dashboard_actions_provider.g.dart';

@riverpod
class DashboardActions extends _$DashboardActions {
  @override
  ActionState<void> build() {
    return const ActionInitial();
  }

  Future<void> addExpense({
    required String flatId,
    required ExpenseEntity expense,
  }) async {
    state = const ActionLoading();
    final auth = ref.read(authStateProvider).value;
    if (auth == null) {
      state = ActionError(Exception('User not authenticated'));
      return;
    }

    final useCase = ref.read(addNewExpenseUseCaseProvider);
    final result = await useCase(flatId: flatId, expense: expense);

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

    final useCase = ref.read(settleUseCaseProvider);
    final result = await useCase(
      flatId: flatId,
      debtId: debtId,
      userId: auth.id,
      userName: auth.displayName ?? auth.email.split('@').first,
    );

    state = result.fold(
      (error) => ActionError(error),
      (_) => const ActionSuccess(null),
    );
  }
}
