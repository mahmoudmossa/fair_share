import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';

/// Computes and upserts the `monthly_history/{monthId}` document for the
/// current calendar month under `wgs/{flatId}/`.
///
/// Call this after any operation that changes the flat's expenses or members:
/// - immediately after [FlatRemoteDataSourceImpl.createFlat]
/// - immediately after [DashboardRemoteDataSourceImpl.addExpense]
///
/// The document fields written are:
/// - `total`    — sum of all expense amounts whose date falls in the month
/// - `myShare`  — total divided evenly by the current member count
/// - `lockedAt` — timestamp of this calculation (updated on every write)
Future<void> upsertMonthlyHistory(
  FirebaseFirestore firestore,
  String flatId,
) async {
  final now = DateTime.now();
  final monthId = _getMonthId(now);

  // Build the month date range [start, end)
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, now.month + 1, 1);

  final flatRef = firestore.collection(FirestoreConstants.wgs).doc(flatId);

  // 1. Fetch members to get member count
  final membersSnap =
      await flatRef.collection(FirestoreConstants.members).get();
  final membersCount = membersSnap.docs.length;

  // 2. Fetch expenses for the current month.
  // The expense model serializes its date field as 'date' (see ExpenseModel.toJson).
  final expensesSnap = await flatRef
      .collection(FirestoreConstants.expenses)
      .where(
        'date',
        isGreaterThanOrEqualTo: Timestamp.fromDate(start),
        isLessThan: Timestamp.fromDate(end),
      )
      .get();

  // 3. Compute totals
  double total = 0.0;
  for (final doc in expensesSnap.docs) {
    final amount = (doc.data()['amount'] as num?)?.toDouble() ?? 0.0;
    total += amount;
  }
  final double myShare =
      membersCount > 0 ? total / membersCount : total;

  // 4. Upsert monthly_history document — merge so we never overwrite other fields
  await flatRef.collection(FirestoreConstants.monthlyHistory).doc(monthId).set(
    {
      'total': total,
      'myShare': myShare,
      'lockedAt': Timestamp.fromDate(now),
    },
    SetOptions(merge: true),
  );
}

String _getMonthId(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}';
