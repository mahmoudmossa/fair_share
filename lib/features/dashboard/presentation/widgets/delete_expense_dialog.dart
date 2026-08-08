import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_actions_provider.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';

class DeleteExpenseDialog extends HookConsumerWidget {
  final String flatId;
  final ExpenseEntity expense;
  final List<FlatMemberEntity> members;

  const DeleteExpenseDialog({
    super.key,
    required this.flatId,
    required this.expense,
    required this.members,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isConfirmed = useState<bool>(false);
    final actionState = ref.watch(dashboardActionsProvider);

    // Close on success
    ref.listen(dashboardActionsProvider, (prev, next) {
      if (next is ActionSuccess<void>) {
        Navigator.of(context).pop();
      }
    });

    void handleDelete() {
      if (!isConfirmed.value) return;

      final recipientUserIds = members
          .map((m) => m.userId ?? m.id)
          .where((uid) => uid.isNotEmpty)
          .toList();

      ref.read(dashboardActionsProvider.notifier).deleteExpense(
            flatId: flatId,
            expenseId: expense.id,
            expenseTitle: expense.title,
            recipientUserIds: recipientUserIds,
          );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.dashboard_delete_expense.tr(),
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '${expense.title} (${expense.amount.toStringAsFixed(2)}€)',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                key: const Key('deleteExpenseConfirmationCheckbox'),
                value: isConfirmed.value,
                onChanged: (val) {
                  isConfirmed.value = val ?? false;
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  LocaleKeys.dashboard_delete_expense_confirmation.tr(),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      LocaleKeys.dashboard_cancel.tr(),
                      style: TextStyle(
                        color: colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: ElevatedButton(
                      key: const Key('confirmDeleteExpenseButton'),
                      onPressed: actionState is ActionLoading || !isConfirmed.value
                          ? null
                          : handleDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: actionState is ActionLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              LocaleKeys.dashboard_delete_expense_btn.tr(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
