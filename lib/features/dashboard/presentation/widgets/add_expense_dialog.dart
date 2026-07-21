import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import '../providers/dashboard_actions_provider.dart';

class AddExpenseDialog extends HookConsumerWidget {
  final String flatId;

  const AddExpenseDialog({super.key, required this.flatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final titleController = useTextEditingController();
    final amountController = useTextEditingController();
    final selectedCategory = useState('other');

    final actionState = ref.watch(dashboardActionsProvider);

    // Close on success
    ref.listen(dashboardActionsProvider, (prev, next) {
      if (next is ActionSuccess<void>) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.login_auth_success.tr()), // Reusing success
            backgroundColor: colorScheme.primary,
          ),
        );
      }
    });

    final categories = [
      {
        'value': 'electricity',
        'label': LocaleKeys.dashboard_category_electricity.tr(),
      },
      {
        'value': 'internet',
        'label': LocaleKeys.dashboard_category_internet.tr(),
      },
      {
        'value': 'groceries',
        'label': LocaleKeys.dashboard_category_groceries.tr(),
      },
      {
        'value': 'other',
        'label': LocaleKeys.dashboard_category_other.tr(),
      },
    ];


    void submit() {
      final title = titleController.text.trim();
      final amount = double.tryParse(amountController.text.trim()) ?? 0.0;

      if (title.isEmpty || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.dashboard_validation_empty_fields.tr()),
            backgroundColor: colorScheme.error,
          ),
        );
        return;
      }

      ref.read(dashboardActionsProvider.notifier).addExpense(
            flatId: flatId,
            title: title,
            amount: amount,
            category: selectedCategory.value,
          );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              LocaleKeys.dashboard_add_expense.tr(),
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Title Input
            TextFormField(
              key: const Key('expenseTitleField'),
              controller: titleController,
              decoration: InputDecoration(
                labelText: LocaleKeys.dashboard_expense_title.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            // Amount Input
            TextFormField(
              key: const Key('expenseAmountField'),
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: LocaleKeys.dashboard_expense_amount.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            // Category Dropdown
            DropdownButtonFormField<String>(
              key: const Key('expenseCategoryDropdown'),
              value: selectedCategory.value,
              decoration: InputDecoration(
                labelText: LocaleKeys.dashboard_expense_category.tr(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: categories.map((cat) {
                return DropdownMenuItem<String>(
                  value: cat['value'],
                  child: Text(cat['label']!),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) selectedCategory.value = val;
              },
            ),
            const SizedBox(height: 24),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    LocaleKeys.dashboard_cancel.tr(),
                    style: TextStyle(color: colorScheme.outline, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  key: const Key('saveExpenseButton'),
                  onPressed: actionState is ActionLoading ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: actionState is ActionLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          LocaleKeys.dashboard_save.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
