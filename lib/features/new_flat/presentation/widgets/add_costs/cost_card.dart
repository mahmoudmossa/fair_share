import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
import 'package:fair_share/features/new_flat/domain/entities/recurrence_type.dart';
import '../../provider/flat_setup_provider.dart';

class CostCard extends HookConsumerWidget {
  const CostCard({super.key, required this.index, required this.onRemove});

  final int index;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final flatSetup = ref.watch(flatSetupProvider);
    if (index >= flatSetup.costs.length) return const SizedBox.shrink();

    final cost = flatSetup.costs[index];

    final titleController = useTextEditingController(text: cost.title);
    final amountController = useTextEditingController(
      text: cost.amount == 0.0 ? '' : cost.amount.toString(),
    );

    // Build complete list of selectable members (Admin Creator + setup members)
    final creatorMember = FlatMemberEntity(
      id: flatSetup.createdBy,
      name: flatSetup.createdByName,
      userId: flatSetup.createdBy,
    );
    final allMembers = [creatorMember, ...flatSetup.members];

    // Find currently selected member by matching payerId
    final selectedMember = allMembers.firstWhere(
      (m) => m.id == cost.payerId,
      orElse: () => allMembers.first,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.new_flat_setup_cost_number.tr(
                  args: [(index + 1).toString()],
                ),
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (index > 0)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: colorScheme.error,
                  onPressed: onRemove,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.new_flat_setup_cost_title_label.tr(),
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: titleController,
                      onChanged: (val) => ref
                          .read(flatSetupProvider.notifier)
                          .updateCost(index, title: val),
                      decoration: InputDecoration(
                        hintText: LocaleKeys.new_flat_setup_cost_title_hint
                            .tr(),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.new_flat_setup_amount_label.tr(),
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (val) => ref
                          .read(flatSetupProvider.notifier)
                          .updateCost(
                            index,
                            amount: double.tryParse(val) ?? 0.0,
                          ),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.new_flat_setup_paid_by_label.tr(),
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 4),
                    DropdownButtonFormField<FlatMemberEntity>(
                      initialValue: selectedMember,
                      items: allMembers
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
                        if (member == null) return;
                        ref
                            .read(flatSetupProvider.notifier)
                            .updateCost(
                              index,
                              payerId: member.id,
                              payerName: member.name,
                            );
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
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.new_flat_setup_frequency_label.tr(),
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SegmentedButton<bool>(
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
                      selected: {cost.recurrenceType == RecurrenceType.monthly},
                      onSelectionChanged: (val) => ref
                          .read(flatSetupProvider.notifier)
                          .updateCost(
                            index,
                            recurrenceType: val.first
                                ? RecurrenceType.monthly
                                : RecurrenceType.oneTime,
                          ),
                      style: SegmentedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
