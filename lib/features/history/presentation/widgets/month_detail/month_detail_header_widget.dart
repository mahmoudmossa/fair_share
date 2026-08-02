import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'month_detail_summary_tile_widget.dart';

class MonthDetailHeaderWidget extends StatelessWidget {
  const MonthDetailHeaderWidget({
    super.key,
    required this.monthLabel,
    this.total,
    this.myShare,
  });

  final String monthLabel;
  final double? total;
  final double? myShare;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            monthLabel,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MonthDetailSummaryTileWidget(
                  label: LocaleKeys.history_detail_summary_total.tr(),
                  amount: total,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MonthDetailSummaryTileWidget(
                  label: LocaleKeys.history_detail_summary_my_share.tr(),
                  amount: myShare,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  highlightValue: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
