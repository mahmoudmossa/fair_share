import 'package:easy_localization/easy_localization.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:fair_share/features/history/domain/entities/month_summary_entity.dart';
import 'watch_monthly_history_use_case_provider.dart';

part 'monthly_history_provider.g.dart';

@riverpod
Stream<List<MonthSummaryEntity>> monthlyHistory(Ref ref) async* {
  final user = await ref.watch(firestoreUserProvider.future);
  final flatId = user?.flatId;
  if (flatId == null || flatId.isEmpty) {
    yield [];
    return;
  }

  final dashboardState = ref.watch(dashboardStateProvider).value;
  final memberCount = dashboardState?.members.length ?? 1;

  final expensesStream = ref
      .watch(watchMonthlyHistoryUseCaseProvider)
      .call(flatId);

  await for (final expenses in expensesStream) {
    final Map<String, double> totalsByMonth = {};
    final Map<String, DateTime> datesByMonth = {};
    for (final exp in expenses) {
      final date = exp.date;
      final monthId = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      totalsByMonth[monthId] = (totalsByMonth[monthId] ?? 0.0) + exp.amount;
      datesByMonth[monthId] = date;
    }

    final sortedMonthIds = totalsByMonth.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    final summaries = sortedMonthIds.map((monthId) {
      final total = totalsByMonth[monthId] ?? 0.0;
      final myShare = memberCount > 0 ? total / memberCount : total;
      final date = datesByMonth[monthId] ?? DateTime.now();
      final monthLabel = DateFormat('MMM yyyy').format(date);

      return MonthSummaryEntity(
        monthId: monthId,
        monthLabel: monthLabel,
        total: total,
        myShare: myShare,
        lockedAt: DateTime.now(),
      );
    }).toList();

    yield summaries;
  }
}
