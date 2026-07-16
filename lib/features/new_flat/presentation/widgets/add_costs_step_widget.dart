import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'add_costs/cost_card.dart';

class AddCostsStepWidget extends HookWidget {
  const AddCostsStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final costCount = useState(1);

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
            costCount.value,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: CostCard(),
            ),
          ),
          TextButton.icon(
            key: AppKeys.newFlat.addCostButton,
            onPressed: () => costCount.value++,
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
