import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';

abstract class HistoryRepository {
  /// Watches all expenses under the flat document.
  Stream<List<ExpenseEntity>> watchAllExpenses(String flatId);

  /// Watches all expenses for a given month (filtered by [monthId] = "YYYY-MM").
  /// Reuses [ExpenseEntity] from the dashboard feature.
  Stream<List<ExpenseEntity>> watchExpensesForMonth(
    String flatId,
    String monthId,
  );
}
