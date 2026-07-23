import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import '../provider/flat_setup_provider.dart';

class CreateFlatStepWidget extends HookConsumerWidget {
  const CreateFlatStepWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flatSetup = ref.watch(flatSetupProvider);
    final controller = useTextEditingController(text: flatSetup.name);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        key: const ValueKey('create_flat_view'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            LocaleKeys.flat_setup_create_title.tr(),
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.flat_setup_create_subtitle.tr(),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Flat Name Input
          TextFormField(
            key: const Key('flatNameField'),
            controller: controller,
            style: const TextStyle(fontFamily: 'Inter'),
            textInputAction: TextInputAction.done,
            onChanged: (val) => ref.read(flatSetupProvider.notifier).updateFlatName(val),
            decoration: InputDecoration(
              labelText: LocaleKeys.flat_setup_flat_name_label.tr(),
              prefixIcon: const Icon(Icons.home_work_outlined),
              labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
              floatingLabelStyle: TextStyle(color: colorScheme.primary),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outlineVariant, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
