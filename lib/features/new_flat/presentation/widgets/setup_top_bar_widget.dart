import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';

class SetupTopBar extends StatelessWidget {
  const SetupTopBar({super.key, required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 56,
      child: Row(
        children: [
          IconButton(
            key: AppKeys.newFlat.backButton,
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          ),
          Expanded(
            child: Text(
              LocaleKeys.new_flat_setup_title.tr(),
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
          TextButton(
            key: AppKeys.newFlat.cancelButton,
            onPressed: onCancel,
            child: Text(
              LocaleKeys.new_flat_setup_cancel.tr(),
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
