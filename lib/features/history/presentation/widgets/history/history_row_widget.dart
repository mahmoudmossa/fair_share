import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/features/history/domain/entities/month_summary_entity.dart';

class HistoryRowWidget extends ConsumerWidget {
  const HistoryRowWidget({
    super.key,
    required this.entity,
    required this.isEven,
    required this.onTap,
  });

  final MonthSummaryEntity entity;
  final bool isEven;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlternatingTableRowContainer(
      keyName: AppKeys.history.historyRow(entity.monthId),
      isEven: isEven,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              entity.monthLabel,
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '€${entity.total.toStringAsFixed(2)}',
              textAlign: TextAlign.end,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              '€${entity.myShare.toStringAsFixed(2)}',
              textAlign: TextAlign.end,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
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
