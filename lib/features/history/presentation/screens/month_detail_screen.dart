import 'package:shared_ui/shared_ui.dart';
import 'package:fair_share/features/notifications/presentation/widgets/notification_icon_widget.dart';
import 'package:fair_share/features/notifications/presentation/widgets/notifications_side_sheet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/core/utils/date_utils_converter.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:fair_share/features/history/domain/entities/month_summary_entity.dart';
import 'package:fair_share/features/history/presentation/providers/month_expenses_for_current_user_provider.dart';
import 'package:fair_share/features/history/presentation/widgets/month_detail/month_detail_empty_widget.dart';
import 'package:fair_share/features/history/presentation/widgets/month_detail/month_detail_header_widget.dart';
import 'package:fair_share/features/history/presentation/widgets/month_detail/month_expense_item_widget.dart';

@RoutePage()
class MonthDetailScreen extends HookConsumerWidget {
  const MonthDetailScreen({
    super.key,
    @PathParam('monthId') required this.monthId,
    this.summary,
  });

  final String monthId;
  final MonthSummaryEntity? summary;

  String get _monthLabel => DateUtilsConverter.formatMonthLabel(monthId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final userAsync = ref.watch(firestoreUserProvider);
    final expensesAsync = ref.watch(
      monthExpensesForCurrentUserProvider(monthId),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(
        title: _monthLabel,
        titleKey: AppKeys.history.monthDetailTitle,
        leading: IconButton(
          key: AppKeys.history.monthDetailBackButton,
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.router.maybePop(),
        ),
        notificationIcon: const NotificationIconWidget(),
      ),
      endDrawer: const NotificationsSideSheet(),
      body: Column(
        children: [
          MonthDetailHeaderWidget(
            monthLabel: _monthLabel,
            total: summary?.total,
            myShare: summary?.myShare,
          ),
          Expanded(
            child: expensesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    LocaleKeys.history_detail_loading_error.tr(
                      args: [err.toString()],
                    ),
                    style: TextStyle(color: colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (expenses) {
                if (expenses.isEmpty) {
                  return const MonthDetailEmptyWidget();
                }
                return userAsync.maybeWhen(
                  data: (user) => ListView.builder(
                    key: AppKeys.history.monthDetailExpenseList,
                    itemCount: expenses.length,
                    itemBuilder: (context, index) => MonthExpenseItemWidget(
                      expense: expenses[index],
                      currentUserId: user?.id ?? '',
                      membersCount: 1,
                    ),
                  ),
                  orElse: () => ListView.builder(
                    key: AppKeys.history.monthDetailExpenseList,
                    itemCount: expenses.length,
                    itemBuilder: (context, index) => MonthExpenseItemWidget(
                      expense: expenses[index],
                      currentUserId: '',
                      membersCount: 1,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
