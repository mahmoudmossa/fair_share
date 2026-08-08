import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';

abstract class HistoryRemoteDataSource {
  /// Watches all expenses under the flat document.
  Stream<List<ExpenseEntity>> watchAllExpenses(String flatId);

  /// Watches all expenses and filters by [monthId] ("YYYY-MM") client-side.
  Stream<List<ExpenseEntity>> watchExpensesForMonth(
    String flatId,
    String monthId,
  );
}
