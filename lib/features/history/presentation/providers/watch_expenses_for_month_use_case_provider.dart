import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/history/domain/use_cases/watch_expenses_for_month_use_case.dart';
import 'history_repository_provider.dart';

part 'watch_expenses_for_month_use_case_provider.g.dart';

@riverpod
WatchExpensesForMonthUseCase watchExpensesForMonthUseCase(Ref ref) {
  return WatchExpensesForMonthUseCase(ref.watch(historyRepositoryProvider));
}
