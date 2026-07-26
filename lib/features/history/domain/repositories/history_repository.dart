import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import '../entities/month_summary_entity.dart';

abstract class HistoryRepository {
  /// Watches the `monthly_history` subcollection under the flat document.
  /// Returns a list of [MonthSummaryEntity] for months that have been locked by admin.
  Stream<List<MonthSummaryEntity>> watchMonthlyHistory(String flatId);

  /// Watches all expenses for a given month (filtered by [monthId] = "YYYY-MM").
  /// Reuses [ExpenseEntity] from the dashboard feature.
  Stream<List<ExpenseEntity>> watchExpensesForMonth(
    String flatId,
    String monthId,
  );
}
