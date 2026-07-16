import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';

class SetupBottomBar extends StatelessWidget {
  const SetupBottomBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  bool get _isLastStep => currentStep == totalSteps - 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            key: AppKeys.newFlat.previousButton,
            onPressed: currentStep > 0 ? onPrevious : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              side: BorderSide(color: colorScheme.outline),
              shape: const StadiumBorder(),
            ),
            icon: const Icon(Icons.chevron_left),
            label: Text(
              LocaleKeys.new_flat_setup_previous.tr(),
              style: textTheme.labelLarge,
            ),
          ),
          FilledButton.icon(
            key: _isLastStep
                ? AppKeys.newFlat.finishButton
                : AppKeys.newFlat.continueButton,
            onPressed: onNext,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: const StadiumBorder(),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            label: Text(
              _isLastStep
                  ? LocaleKeys.new_flat_setup_finish.tr()
                  : LocaleKeys.new_flat_setup_continue.tr(),
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(Icons.chevron_right),
            iconAlignment: IconAlignment.end,
          ),
        ],
      ),
    );
  }
}
