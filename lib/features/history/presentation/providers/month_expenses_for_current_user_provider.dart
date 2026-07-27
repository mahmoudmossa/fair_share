import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'watch_expenses_for_month_use_case_provider.dart';

part 'month_expenses_for_current_user_provider.g.dart';

/// Convenience provider that resolves flatId asynchronously from current user.
@riverpod
Stream<List<ExpenseEntity>> monthExpensesForCurrentUser(
  Ref ref,
  String monthId,
) async* {
  final user = await ref.watch(firestoreUserProvider.future);
  final flatId = user?.flatId;
  if (flatId == null || flatId.isEmpty) {
    yield [];
    return;
  }

  yield* ref
      .watch(watchExpensesForMonthUseCaseProvider)
      .call(flatId, monthId);
}
