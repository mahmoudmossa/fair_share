import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/core/router/app_router.dart';
import 'package:fair_share/features/history/domain/entities/month_summary_entity.dart';
import 'history_row_widget.dart';
import 'history_sticky_header_delegate.dart';
import 'history_table_header_widget.dart';

class HistoryTableContentWidget extends StatelessWidget {
  const HistoryTableContentWidget({
    super.key,
    required this.months,
  });

  final List<MonthSummaryEntity> months;

  @override
  Widget build(BuildContext context) {
    if (months.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            LocaleKeys.history_no_data.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: HistoryStickyHeaderDelegate(
            child: const HistoryTableHeaderWidget(),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final entity = months[index];
              final isEven = index.isEven;

              return HistoryRowWidget(
                entity: entity,
                isEven: isEven,
                onTap: () => context.pushRoute(
                  MonthDetailRoute(
                    monthId: entity.monthId,
                    summary: entity,
                  ),
                ),
              );
            },
            childCount: months.length,
          ),
        ),
      ],
    );
  }
}
