import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/history/domain/use_cases/watch_monthly_history_use_case.dart';
import 'history_repository_provider.dart';

part 'watch_monthly_history_use_case_provider.g.dart';

@riverpod
WatchMonthlyHistoryUseCase watchMonthlyHistoryUseCase(Ref ref) {
  return WatchMonthlyHistoryUseCase(ref.watch(historyRepositoryProvider));
}
