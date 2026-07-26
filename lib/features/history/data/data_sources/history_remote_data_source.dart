import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import 'package:fair_share/features/history/domain/entities/month_summary_entity.dart';

abstract class HistoryRemoteDataSource {
  /// Watches the `monthly_history` subcollection for all locked months.
  Stream<List<MonthSummaryEntity>> watchMonthlyHistory(String flatId);

  /// Watches all expenses and filters by [monthId] ("YYYY-MM") client-side.
  Stream<List<ExpenseEntity>> watchExpensesForMonth(
    String flatId,
    String monthId,
  );
}
