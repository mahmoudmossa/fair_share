import 'package:shared_ui/shared_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fair_share/features/dashboard/presentation/widgets/add_expense_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/core/router/app_router.dart';
import 'package:fair_share/core/router/providers/app_router_provider.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_notifier_provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/dashboard_flat_provider.dart';
import '../providers/flat_members_provider.dart';
import '../providers/active_billing_cycle_provider.dart';
import '../providers/dashboard_expenses_provider.dart';
import '../providers/dashboard_activities_provider.dart';
import '../providers/flat_debts_provider.dart';
import '../widgets/bento_summary_widget.dart';
import '../widgets/debt_matrix_widget.dart';
import '../widgets/itemized_expenses_widget.dart';
import '../widgets/activity_feed_widget.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/features/history/presentation/screens/history_screen.dart';
import 'package:fair_share/features/profile/presentation/screens/profile_screen.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:fair_share/features/occupants/presentation/widget/occupants_widget.dart';
import 'package:fair_share/features/notifications/presentation/widgets/notification_icon_widget.dart';
import 'package:fair_share/features/notifications/presentation/providers/fcm_token_notifier.dart';
import 'package:fair_share/features/notifications/presentation/widgets/notifications_side_sheet.dart';

@RoutePage()
class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentTab = useState(0);

    final userAsync = ref.watch(firestoreUserProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Text(
            LocaleKeys.dashboard_error_loading_user.tr(args: [err.toString()]),
          ),
        ),
      ),
      data: (user) {
        if (user == null) {
          Future.microtask(
            () => ref.read(appRouterProvider).replace(LoginRoute()),
          );
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (user.flatId == null || user.flatId!.isEmpty) {
          Future.microtask(
            () => ref
                .read(appRouterProvider)
                .replace(const JoinOrCreateFlatRoute()),
          );
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        useEffect(() {
          Future.microtask(() {
            ref.read(fcmTokenProvider.notifier).syncFcmToken();
          });
          return null;
        }, const []);

        final flatAsync = ref.watch(dashboardFlatProvider);
        final membersAsync = ref.watch(flatMembersProvider);

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppHeader(
            title: _getTitleForTab(currentTab.value),
            titleKey: currentTab.value == 3 ? AppKeys.profile.profileTitle : null,
            avatarWidget: currentTab.value == 0
                ? Builder(
                    builder: (context) {
                      final members = membersAsync.value ?? [];
                      final currentMember = members.where((m) => m.id == user.id || m.userId == user.id).firstOrNull;
                      final displayName = currentMember?.name ?? '';
                      final photoBase64 = currentMember?.photoBase64;
                      return MemberAvatarWidget(
                        displayName: displayName,
                        photoBase64: photoBase64,
                        radius: 18,
                      );
                    },
                  )
                : null,
            notificationIcon: const NotificationIconWidget(),
            actions: currentTab.value == 0
                ? [
                    IconButton(
                      onPressed: () {
                        ref.read(authProvider.notifier).signOut().then((_) {
                          ref.read(appRouterProvider).replaceAll([
                            LoginRoute(),
                          ]);
                        });
                      },
                      icon: Icon(Icons.logout, color: colorScheme.outline),
                      tooltip: LocaleKeys.flat_setup_logout.tr(),
                    ),
                  ]
                : null,
          ),
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildBodyForTab(
                context,
                currentTab.value,
                user.id,
                user.flatId!,
                ref,
              ),
            ),
          ),
          endDrawer: const NotificationsSideSheet(),
          floatingActionButton: currentTab.value == 0
              ? flatAsync.maybeWhen(
                  data: (flat) {
                    if (flat == null) return null;
                    final members = membersAsync.value ?? [];
                    return FloatingActionButton(
                      key: const Key('addExpenseFab'),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: const CircleBorder(),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddExpenseDialog(
                            flatId: flat.id,
                            members: members,
                          ),
                        );
                      },
                      child: const Icon(Icons.add, size: 28),
                    );
                  },
                  orElse: () => null,
                )
              : null,
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentTab.value,
            onDestinationSelected: (idx) => currentTab.value = idx,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard),
                label: LocaleKeys.dashboard_title.tr(),
              ),
              NavigationDestination(
                key: const Key('historyNavTab'),
                icon: const Icon(Icons.receipt_long_outlined),
                selectedIcon: const Icon(Icons.receipt_long),
                label: LocaleKeys.dashboard_history_tab.tr(),
              ),
              NavigationDestination(
                icon: const Icon(Icons.group_outlined),
                selectedIcon: const Icon(Icons.group),
                label: LocaleKeys.dashboard_admin_tab.tr(),
              ),
              NavigationDestination(
                key: AppKeys.profile.profileTab,
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: LocaleKeys.dashboard_profile_tab.tr(),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTitleForTab(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return LocaleKeys.history_title.tr();
      case 2:
        return LocaleKeys.dashboard_admin_tab.tr();
      case 3:
        return LocaleKeys.dashboard_profile_tab.tr();
      case 0:
      default:
        return LocaleKeys.dashboard_title.tr();
    }
  }

  Widget _buildBodyForTab(
    BuildContext context,
    int tabIndex,
    String currentUserId,
    String flatId,
    WidgetRef ref,
  ) {
    if (tabIndex == 1) {
      return const HistoryScreen(key: ValueKey('tab_1'));
    }

    if (tabIndex == 2) {
      final flatAsync = ref.watch(dashboardFlatProvider);
      final membersAsync = ref.watch(flatMembersProvider);

      return flatAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
        data: (flat) {
          if (flat == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final members = membersAsync.value ?? [];
          final occupantsList = members
              .map(
                (m) => Occupant(
                  id: m.id,
                  name: m.name,
                  userId: m.userId,
                  invitationCode: m.invitationCode,
                  flatId: flat.id,
                ),
              )
              .toList();

          final isCurrentAdmin = flat.createdBy == currentUserId;

          return OccupantsWidget(
            key: const ValueKey('tab_2_admin'),
            occupantsList: occupantsList,
            inviteCode: flat.id,
            isCurrentAdmin: isCurrentAdmin,
            currentUserId: currentUserId,
            flatId: flat.id,
            flatName: flat.name,
            initialBillingDay: flat.billingCalculationDay,
          );
        },
      );
    }

    if (tabIndex == 3) {
      return const ProfileScreen(key: ValueKey('tab_3'));
    }

    final flatAsync = ref.watch(dashboardFlatProvider);
    final cycleAsync = ref.watch(activeBillingCycleProvider);
    final expensesAsync = ref.watch(dashboardExpensesProvider);
    final activitiesAsync = ref.watch(dashboardActivitiesProvider);
    final members = ref.watch(flatMembersProvider).value ?? [];

    final colorScheme = Theme.of(context);
    final textTheme = colorScheme.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard Header Section
          cycleAsync.when(
            data: (cycle) {
              if (cycle == null || cycle.monthName == null || cycle.monthName!.isEmpty) {
                return const SizedBox.shrink();
              }
              final flatCreatedByName = flatAsync.value?.createdByName ?? '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cycle.monthName!,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          LocaleKeys.dashboard_created_by.tr(
                            args: [flatCreatedByName],
                          ),
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  BentoSummaryWidget(
                    cycle: cycle,
                    membersCount: members.length,
                  ),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (err, stack) => const SizedBox.shrink(),
          ),

          // Debt Matrix
          ref
              .watch(flatDebtsProvider(flatId))
              .when(
                data: (debts) => DebtMatrixWidget(
                  flatId: flatId,
                  debts: debts,
                  currentUserId: currentUserId,
                  isCurrentAdmin: flatAsync.value?.createdBy == currentUserId,
                  members: members,
                ),
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => Text(err.toString()),
              ),

          // Itemized Expenses
          ItemizedExpensesWidget(
            flatId: flatId,
            expenses: expensesAsync.value ?? [],
            currentUserId: currentUserId,
            members: members,
          ),

          // Recent Activity Feed
          ActivityFeedWidget(activities: activitiesAsync.value ?? []),
        ],
      ),
    );
  }
}

