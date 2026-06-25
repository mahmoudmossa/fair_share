import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/core/router/app_router.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_notifier_provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/dashboard_actions_provider.dart';

@RoutePage()
class JoinOrCreateFlatScreen extends HookConsumerWidget {
  const JoinOrCreateFlatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCreateMode = useState(false);
    final state = ref.watch(dashboardActionsProvider);

    // Listen to Firestore user. If they suddenly get a flatId, send them to dashboard.
    ref.listen(firestoreUserProvider, (prev, next) {
      final user = next.value;
      if (user != null && user.flatId != null && user.flatId!.isNotEmpty) {
        context.router.replace(const DashboardRoute());
      }
    });

    // Listen to action result
    ref.listen(dashboardActionsProvider, (prev, next) {
      if (next is ActionSuccess<void>) {
        context.router.replace(const DashboardRoute());
      } else if (next is ActionError<void>) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString().replaceAll('Exception: ', '')),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          LocaleKeys.dashboard_title.tr(),
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authProvider.notifier).signOut().then((_) {
                if (context.mounted) {
                  context.router.replaceAll([LoginRoute()]);
                }
              });
            },
            icon: Icon(Icons.logout, color: colorScheme.outline),
            tooltip: LocaleKeys.flat_setup_logout.tr(),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isCreateMode.value
                  ? _CreateFlatView(
                      isLoading: state is ActionLoading,
                      onToggle: () => isCreateMode.value = false,
                    )
                  : _JoinFlatView(
                      isLoading: state is ActionLoading,
                      onToggle: () => isCreateMode.value = true,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _JoinFlatView extends HookConsumerWidget {
  final bool isLoading;
  final VoidCallback onToggle;

  const _JoinFlatView({
    required this.isLoading,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // PIN code controller logic (6 digits)
    final controllers = List.generate(6, (_) => useTextEditingController());
    final focusNodes = List.generate(6, (_) => useFocusNode());

    void submitPin() {
      final pin = controllers.map((c) => c.text).join();
      if (pin.length == 6) {
        ref.read(dashboardActionsProvider.notifier).joinFlat(pin);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.dashboard_validation_empty_fields.tr()),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    }

    return Column(
      key: const ValueKey('join_flat_view'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Atmospherical top spacing
        const SizedBox(height: 16),
        Text(
          LocaleKeys.flat_setup_title.tr(),
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.flat_setup_subtitle.tr(),
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),

        // 6 PIN Entry Boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 48,
              height: 64,
              child: TextFormField(
                key: Key('pinDigitField$index'),
                controller: controllers[index],
                focusNode: focusNodes[index],
                autofocus: index == 0,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                maxLength: 1,
                decoration: InputDecoration(
                  counterText: "",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outlineVariant, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (index < 5) {
                      focusNodes[index + 1].requestFocus();
                    } else {
                      focusNodes[index].unfocus();
                    }
                  } else {
                    if (index > 0) {
                      focusNodes[index - 1].requestFocus();
                    }
                  }
                },
              ),
            );
          }),
        ),

        const SizedBox(height: 32),

        // Hint Card
        Card(
          color: colorScheme.surfaceContainerLow,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: colorScheme.tertiary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    LocaleKeys.flat_setup_hint.tr(),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 48),

        // Primary Button
        ElevatedButton.icon(
          key: const Key('joinFlatButton'),
          onPressed: isLoading ? null : submitPin,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.home),
          label: Text(
            LocaleKeys.flat_setup_join_btn.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),

        const SizedBox(height: 16),

        // Alternative Toggle Action
        TextButton(
          key: const Key('toggleCreateFlatModeButton'),
          onPressed: onToggle,
          child: Text(
            LocaleKeys.flat_setup_create_mode_btn.tr(),
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _CreateFlatView extends HookConsumerWidget {
  final bool isLoading;
  final VoidCallback onToggle;

  const _CreateFlatView({
    required this.isLoading,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final nameController = useTextEditingController();

    void submitCreate() {
      final name = nameController.text.trim();
      if (name.isNotEmpty) {
        ref.read(dashboardActionsProvider.notifier).createFlat(name);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.flat_setup_enter_flat_name.tr()),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    }

    return Column(
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
          controller: nameController,
          style: const TextStyle(fontFamily: 'Inter'),
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

        const SizedBox(height: 48),

        // Primary Button
        ElevatedButton.icon(
          key: const Key('createFlatButton'),
          onPressed: isLoading ? null : submitCreate,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.groups),
          label: Text(
            LocaleKeys.flat_setup_create_btn.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),

        const SizedBox(height: 16),

        // Alternative Toggle Action
        TextButton(
          key: const Key('toggleJoinFlatModeButton'),
          onPressed: onToggle,
          child: Text(
            LocaleKeys.flat_setup_join_mode_btn.tr(),
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
