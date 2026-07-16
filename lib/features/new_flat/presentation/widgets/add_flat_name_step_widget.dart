import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';

class AddFlatNameStepWidget extends HookWidget {
  const AddFlatNameStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.home_work_outlined,
                size: 120,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            LocaleKeys.new_flat_setup_step1_headline.tr(),
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            key: AppKeys.newFlat.flatNameField,
            controller: controller,
            style: textTheme.titleMedium,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: LocaleKeys.new_flat_setup_flat_name_label.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
