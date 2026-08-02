import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/core/router/app_router.dart';
import 'package:fair_share/core/router/providers/app_router_provider.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_notifier_provider.dart';

class ProfileGeneralSettingsWidget extends HookConsumerWidget {
  final String flatName;

  const ProfileGeneralSettingsWidget({super.key, required this.flatName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final authNotifier = ref.watch(authProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.profile_general_settings.tr(),
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
          ),
          child: Column(
            children: [
              ListTile(
                key: AppKeys.profile.flatDetailsTile,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.home_outlined,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                title: Text(
                  LocaleKeys.profile_flat_details.tr(),
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  flatName.isNotEmpty ? flatName : 'Unit 4B',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () {},
              ),
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: colorScheme.outlineVariant.withAlpha(50),
              ),
              ListTile(
                key: AppKeys.profile.securityPrivacyTile,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.security_outlined,
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
                title: Text(
                  LocaleKeys.profile_security_privacy.tr(),
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  LocaleKeys.profile_biometrics_data_splitting.tr(),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () {},
              ),
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: colorScheme.outlineVariant.withAlpha(50),
              ),
              ListTile(
                key: AppKeys.profile.logoutButton,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.logout,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                title: Text(
                  LocaleKeys.profile_logout.tr(),
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.error,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: colorScheme.error),
                onTap: () {
                  authNotifier.signOut().then((_) {
                    ref.read(appRouterProvider).replaceAll([LoginRoute()]);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
