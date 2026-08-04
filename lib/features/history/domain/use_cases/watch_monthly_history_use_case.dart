import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import '../repositories/history_repository.dart';

class WatchMonthlyHistoryUseCase {
  const WatchMonthlyHistoryUseCase(this._repository);

  final HistoryRepository _repository;

  Stream<List<ExpenseEntity>> call(String flatId) {
    return _repository.watchAllExpenses(flatId);
  }
}
