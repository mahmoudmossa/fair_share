import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
import '../../domain/entities/expense_entity.dart';
import 'add_expense_dialog.dart';

class ItemizedExpensesWidget extends StatelessWidget {
  final String flatId;
  final List<ExpenseEntity> expenses;
  final String currentUserId;
  final List<FlatMemberEntity> members;

  const ItemizedExpensesWidget({
    super.key,
    required this.flatId,
    required this.expenses,
    required this.currentUserId,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (expenses.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.dashboard_itemized_expenses.tr(),
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expenses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final exp = expenses[index];
              final String payerText = LocaleKeys.dashboard_paid_by.tr(
                args: [exp.payerName, exp.amount.toStringAsFixed(2)],
              );

              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exp.title,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            payerText,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Dispute Warning
                    if (exp.isDisputed)
                      Tooltip(
                        message:
                            exp.disputeReason ??
                            LocaleKeys.dashboard_dispute_open.tr(),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: colorScheme.error,
                          size: 24,
                        ),
                      ),
                    const SizedBox(width: 4),
                    // Edit Icon Button
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: colorScheme.primary,
                        size: 22,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddExpenseDialog(
                            flatId: flatId,
                            members: members,
                            expenseToEdit: exp,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
