import 'package:shared_ui/shared_ui.dart';
import 'package:fair_share/features/notifications/presentation/widgets/notification_icon_widget.dart';
import 'package:fair_share/features/notifications/presentation/widgets/notifications_side_sheet.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/core/router/app_router.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_notifier_provider.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_provider.dart';
import '../widgets/setup_option_card_widget.dart';

@RoutePage()
class JoinOrCreateFlatScreen extends HookConsumerWidget {
  const JoinOrCreateFlatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Listen to Firestore user. If they suddenly get a flatId, send them to dashboard.
    ref.listen(firestoreUserProvider, (prev, next) {
      final user = next.value;
      if (user != null && user.flatId != null && user.flatId!.isNotEmpty) {
        context.router.replace(const DashboardRoute());
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppHeader(
        title: LocaleKeys.dashboard_title.tr(),
        notificationIcon: const NotificationIconWidget(),
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
      endDrawer: const NotificationsSideSheet(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.home_work_outlined,
                      size: 44,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  LocaleKeys.new_flat_setup_title.tr(),
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  LocaleKeys.flat_setup_create_subtitle.tr(),
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                SetupOptionCardWidget(
                  cardKey: const Key('goToCreateFlatButton'),
                  icon: Icons.add_home_work_outlined,
                  title: LocaleKeys.flat_setup_create_title.tr(),
                  description: LocaleKeys.flat_setup_create_subtitle.tr(),
                  onTap: () {
                    context.router.push(const NewFlatRoute());
                  },
                ),
                const SizedBox(height: 16),
                SetupOptionCardWidget(
                  cardKey: AppKeys.joinFlat.goToJoinFlatButton,
                  icon: Icons.vpn_key_outlined,
                  title: LocaleKeys.flat_setup_title.tr(),
                  description: LocaleKeys.flat_setup_subtitle.tr(),
                  onTap: () {
                    context.router.push(const JoinFlatRoute());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
