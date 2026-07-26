import '../entities/month_summary_entity.dart';
import '../repositories/history_repository.dart';

class WatchMonthlyHistoryUseCase {
  const WatchMonthlyHistoryUseCase(this._repository);

  final HistoryRepository _repository;

  Stream<List<MonthSummaryEntity>> call(String flatId) {
    return _repository.watchMonthlyHistory(flatId);
  }
}
