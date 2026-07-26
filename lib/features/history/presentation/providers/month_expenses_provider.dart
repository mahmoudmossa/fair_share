import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import 'package:fair_share/features/history/domain/entities/month_expenses_params.dart';
import 'watch_expenses_for_month_use_case_provider.dart';

part 'month_expenses_provider.g.dart';

@riverpod
Stream<List<ExpenseEntity>> monthExpenses(
  Ref ref,
  MonthExpensesParams params,
) {
  return ref
      .watch(watchExpensesForMonthUseCaseProvider)
      .call(params.flatId, params.monthId);
}
