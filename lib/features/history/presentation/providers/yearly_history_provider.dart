import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:fair_share/features/history/domain/entities/yearly_cost_summary_entity.dart';
import 'watch_monthly_history_use_case_provider.dart';

part 'yearly_history_provider.g.dart';

@riverpod
Stream<List<YearlyCostSummaryEntity>> yearlyHistory(Ref ref) async* {
  final user = await ref.watch(firestoreUserProvider.future);
  final flatId = user?.flatId;
  if (flatId == null || flatId.isEmpty) {
    yield [];
    return;
  }

  final expensesStream = ref
      .watch(watchMonthlyHistoryUseCaseProvider)
      .call(flatId);

  await for (final expenses in expensesStream) {
    final Map<int, double> totalsByYear = {};
    final Map<int, Map<String, double>> categoryBreakdownByYear = {};

    for (final exp in expenses) {
      final year = exp.date.year;
      final categoryOrTitle = exp.title.trim().isNotEmpty ? exp.title.trim() : 'Other';

      totalsByYear[year] = (totalsByYear[year] ?? 0.0) + exp.amount;

      final yearBreakdown = categoryBreakdownByYear.putIfAbsent(year, () => {});
      yearBreakdown[categoryOrTitle] = (yearBreakdown[categoryOrTitle] ?? 0.0) + exp.amount;
    }

    final sortedYears = totalsByYear.keys.toList()..sort((a, b) => b.compareTo(a));

    final summaries = sortedYears.map((year) {
      return YearlyCostSummaryEntity(
        year: year,
        totalAmount: totalsByYear[year] ?? 0.0,
        categoryBreakdown: categoryBreakdownByYear[year] ?? {},
      );
    }).toList();

    yield summaries;
  }
}
