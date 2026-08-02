import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fair_share/features/history/presentation/providers/monthly_history_provider.dart';
import 'history_error_widget.dart';
import 'history_loading_widget.dart';
import 'history_table_content_widget.dart';

class HistoryWidget extends ConsumerWidget {
  const HistoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(monthlyHistoryProvider);

    return historyAsync.when(
      loading: () => const HistoryLoadingWidget(),
      error: (err, _) => HistoryErrorWidget(message: err.toString()),
      data: (months) => HistoryTableContentWidget(months: months),
    );
  }
}
