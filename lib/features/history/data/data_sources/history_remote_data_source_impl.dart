import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import 'package:fair_share/features/dashboard/data/models/expense_model.dart';
import 'package:fair_share/features/history/domain/entities/month_summary_entity.dart';
import '../dtos/month_summary_dto.dart';
import 'history_remote_data_source.dart';

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  const HistoryRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<List<MonthSummaryEntity>> watchMonthlyHistory(String flatId) {
    return _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.monthlyHistory)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => MonthSummaryDto.fromMap(d.data(), d.id).toEntity())
              .toList(),
        );
  }

  @override
  Stream<List<ExpenseEntity>> watchExpensesForMonth(
    String flatId,
    String monthId,
  ) {
    // monthId format: "YYYY-MM"
    final parts = monthId.split('-');
    if (parts.length != 2) return const Stream.empty();

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    if (year == null || month == null) return const Stream.empty();

    // Build date range for the month
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1); // exclusive upper bound

    return _firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.expenses)
        .where(
          FirestoreConstants.timestamp,
          isGreaterThanOrEqualTo: Timestamp.fromDate(start),
          isLessThan: Timestamp.fromDate(end),
        )
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (d) => ExpenseModel.fromMap(d.data(), d.id).toEntity(),
              )
              .toList(),
        );
  }
}
