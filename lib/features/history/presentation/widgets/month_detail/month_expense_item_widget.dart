import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';

class MonthExpenseItemWidget extends ConsumerWidget {
  const MonthExpenseItemWidget({
    super.key,
    required this.expense,
    required this.currentUserId,
    required this.membersCount,
  });

  final ExpenseEntity expense;
  final String currentUserId;
  final int membersCount;

  double get _myShare =>
      membersCount > 0 ? expense.amount / membersCount : expense.amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isMyExpense = expense.payerId == currentUserId;
    final dateLabel = _formatDate(expense.date);

    return Container(
      key: AppKeys.history.expenseItem(expense.id),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: colorScheme.secondaryContainer,
            child: Icon(
              Icons.receipt_long_outlined,
              color: colorScheme.onSecondaryContainer,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${LocaleKeys.history_detail_paid_by.tr(args: [isMyExpense ? 'You' : expense.payerName])} • $dateLabel',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '€${expense.amount.toStringAsFixed(2)}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '€${_myShare.toStringAsFixed(2)}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => DateFormat('d MMM').format(date);
}
