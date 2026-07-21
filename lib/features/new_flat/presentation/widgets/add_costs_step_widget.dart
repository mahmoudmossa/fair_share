import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/features/new_flat/domain/entities/recurrence_type.dart';
import '../provider/flat_setup_provider.dart';
import 'add_costs/cost_card.dart';

class AddCostsStepWidget extends HookConsumerWidget {
  const AddCostsStepWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final flatSetup = ref.watch(flatSetupProvider);

    // Ensure we have at least one cost field initialized at start
    useEffect(() {
      if (flatSetup.costs.isEmpty) {
        Future.microtask(() {
          ref.read(flatSetupProvider.notifier).addCost(
                title: '',
                amount: 0.0,
                recurrenceType: RecurrenceType.oneTime,
                payerId: flatSetup.createdBy,
              );
        });
      }
      return null;
    }, []);

    void addNewCostField() {
      ref.read(flatSetupProvider.notifier).addCost(
            title: '',
            amount: 0.0,
            recurrenceType: RecurrenceType.oneTime,
            payerId: flatSetup.createdBy,
          );
    }

    void removeCostField(int index) {
      ref.read(flatSetupProvider.notifier).removeCost(index);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.new_flat_setup_step3_headline.tr(),
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.new_flat_setup_step3_subtitle.tr(),
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(
            flatSetup.costs.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CostCard(
                index: index,
                onRemove: () => removeCostField(index),
              ),
            ),
          ),
          TextButton.icon(
            key: AppKeys.newFlat.addCostButton,
            onPressed: addNewCostField,
            icon: const Icon(Icons.add_circle_outline),
            label: Text(
              LocaleKeys.new_flat_setup_add_another_cost.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
