import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import '../repositories/history_repository.dart';

class WatchExpensesForMonthUseCase {
  const WatchExpensesForMonthUseCase(this._repository);

  final HistoryRepository _repository;

  Stream<List<ExpenseEntity>> call(String flatId, String monthId) {
    return _repository.watchExpensesForMonth(flatId, monthId);
  }
}
