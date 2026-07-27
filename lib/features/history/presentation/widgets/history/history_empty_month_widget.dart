import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:fair_share/core/constants/app_keys.dart';

class HistoryEmptyMonthWidget extends ConsumerWidget {
  const HistoryEmptyMonthWidget({
    super.key,
    required this.monthLabel,
    required this.isEven,
    required this.onTap,
  });

  final String monthLabel;
  final bool isEven;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlternatingTableRowContainer(
      keyName: AppKeys.history.historyEmptyRow(monthLabel),
      isEven: isEven,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              monthLabel,
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: EmptyValueDashWidget(),
          ),
          const SizedBox(width: 12),
          const Expanded(
            flex: 2,
            child: EmptyValueDashWidget(),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
