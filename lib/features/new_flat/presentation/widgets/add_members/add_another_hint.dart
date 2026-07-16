import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';

class AddAnotherHint extends StatelessWidget {
  const AddAnotherHint({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_add_outlined,
            color: colorScheme.outlineVariant,
          ),
          const SizedBox(width: 8),
          Text(
            LocaleKeys.new_flat_setup_add_another_member.tr(),
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.outlineVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
