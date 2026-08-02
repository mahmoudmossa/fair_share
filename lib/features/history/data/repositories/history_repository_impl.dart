import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import 'package:fair_share/features/history/domain/entities/month_summary_entity.dart';
import 'package:fair_share/features/history/domain/repositories/history_repository.dart';
import '../data_sources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  const HistoryRepositoryImpl(this._remoteDataSource);

  final HistoryRemoteDataSource _remoteDataSource;

  @override
  Stream<List<MonthSummaryEntity>> watchMonthlyHistory(String flatId) {
    return _remoteDataSource.watchMonthlyHistory(flatId).handleError((error) {
      if (error is FirebaseException) {
        throw FirebaseErrorMapper().mapException(error);
      }
      throw error;
    });
  }

  @override
  Stream<List<ExpenseEntity>> watchExpensesForMonth(
    String flatId,
    String monthId,
  ) {
    return _remoteDataSource
        .watchExpensesForMonth(flatId, monthId)
        .handleError((error) {
          if (error is FirebaseException) {
            throw FirebaseErrorMapper().mapException(error);
          }
          throw error;
        });
  }
}
