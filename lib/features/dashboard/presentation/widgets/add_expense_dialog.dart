import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
import 'package:fair_share/features/new_flat/domain/entities/recurrence_type.dart';
import '../../domain/entities/expense_entity.dart';
import '../providers/dashboard_actions_provider.dart';
import '../providers/dashboard_provider.dart';

class AddExpenseDialog extends HookConsumerWidget {
  final String flatId;
  final List<FlatMemberEntity> members;

  const AddExpenseDialog({
    super.key,
    required this.flatId,
    required this.members,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final titleController = useTextEditingController();
    final amountController = useTextEditingController();
    final selectedMember = useState<FlatMemberEntity?>(() {
      if (members.isEmpty) return null;
      final user = ref.read(firestoreUserProvider).value;
      return members.firstWhere(
        (m) => m.userId == user?.id || m.id == user?.id,
        orElse: () => members.first,
      );
    }());
    final recurrence = useState<RecurrenceType>(RecurrenceType.oneTime);

    final actionState = ref.watch(dashboardActionsProvider);

    // Close on success
    ref.listen(dashboardActionsProvider, (prev, next) {
      if (next is ActionSuccess<void>) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              LocaleKeys.login_auth_success.tr(),
            ), // Reusing success
            backgroundColor: colorScheme.primary,
          ),
        );
      }
    });

    void submit() {
      if (formKey.currentState?.validate() ?? false) {
        final title = titleController.text.trim();
        final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
        final payer = selectedMember.value;

        if (payer == null) return;

        final expense = ExpenseEntity(
          id: '',
          title: title,
          amount: amount,
          payerId: payer.id,
          payerName: payer.name,
          date: DateTime.now(),
          isDisputed: false,
          recurrence: recurrence.value,
        );

        final recipientUserIds = members
            .map((m) => m.userId ?? m.id)
            .where((uid) => uid.isNotEmpty)
            .toList();

        ref
            .read(dashboardActionsProvider.notifier)
            .addExpense(
              flatId: flatId,
              expense: expense,
              recipientUserIds: recipientUserIds,
            );
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
              ExpenseFormFields(
                titleController: titleController,
                amountController: amountController,
                titleKey: const Key('expenseTitleField'),
                amountKey: const Key('expenseAmountField'),
                titleLabel: LocaleKeys.new_flat_setup_cost_title_label.tr(),
                titleHint: LocaleKeys.new_flat_setup_cost_title_hint.tr(),
                amountLabel: LocaleKeys.new_flat_setup_amount_label.tr(),
                amountHint: '0.00',
                paidByLabel: LocaleKeys.new_flat_setup_paid_by_label.tr(),
                frequencyLabel: LocaleKeys.new_flat_setup_frequency_label.tr(),
                titleValidator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return LocaleKeys.dashboard_validation_empty_fields.tr();
                  }
                  return null;
                },
                amountValidator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return LocaleKeys.dashboard_validation_empty_fields.tr();
                  }
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null || parsed <= 0) {
                    return LocaleKeys.new_flat_setup_invalid_costs_error.tr();
                  }
                  return null;
                },
                payerDropdown: DropdownButtonFormField<FlatMemberEntity>(
                  key: ValueKey(
                    'expensePayerDropdown_${selectedMember.value?.id}',
                  ),
                  initialValue: selectedMember.value,
                  items: members
                      .map(
                        (member) => DropdownMenuItem<FlatMemberEntity>(
                          value: member,
                          child: Text(
                            member.name,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (member) {
                    if (member != null) {
                      selectedMember.value = member;
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return LocaleKeys.dashboard_validation_empty_fields.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                frequencySegmentedButton: SegmentedButton<bool>(
                  key: const Key('expenseFrequencySegmentedButton'),
                  segments: [
                    ButtonSegment(
                      value: true,
                      label: Text(
                        LocaleKeys.new_flat_setup_recurring_monthly.tr(),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text(
                        LocaleKeys.new_flat_setup_one_time.tr(),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                  selected: {recurrence.value == RecurrenceType.monthly},
                  onSelectionChanged: (val) {
                    recurrence.value = val.first
                        ? RecurrenceType.monthly
                        : RecurrenceType.oneTime;
                  },
                  style: SegmentedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
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
                  ElevatedButton(
                    key: const Key('saveExpenseButton'),
                    onPressed: actionState is ActionLoading ? null : submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
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
                            LocaleKeys.dashboard_save.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
