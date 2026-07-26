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

  yield* ref
      .watch(watchMonthlyHistoryUseCaseProvider)
      .call(flatId);
}
