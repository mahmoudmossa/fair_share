import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import 'package:fair_share/features/dashboard/domain/repositories/dashboard_repository.dart';

class WatchExpensesUseCase {
  final DashboardRepository _repository;

  WatchExpensesUseCase(this._repository);

  Stream<List<ExpenseEntity>> call(String flatId) {
    return _repository.watchExpenses(flatId);
  }
}
