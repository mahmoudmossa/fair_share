import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/core/router/app_router.dart';
import 'package:fair_share/core/router/providers/app_router_provider.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_notifier_provider.dart';
import 'package:fair_share/features/dashboard/domain/entities/dashboard_state.dart';
import '../providers/dashboard_provider.dart';
import '../providers/flat_debts_provider.dart';
import '../widgets/bento_summary_widget.dart';
import '../widgets/debt_matrix_widget.dart';
import '../widgets/itemized_expenses_widget.dart';
import '../widgets/activity_feed_widget.dart';
import '../widgets/add_expense_dialog.dart';

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
          // Fallback if auth state is lost
          Future.microtask(
            () => ref.read(appRouterProvider).replace(LoginRoute()),
          );
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (user.flatId == null || user.flatId!.isEmpty) {
          // If the user has no flat, redirect to the Setup/Join/Create flow
          Future.microtask(
            () => ref
                .read(appRouterProvider)
                .replace(const JoinOrCreateFlatRoute()),
          );
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final stateAsync = ref.watch(dashboardStateProvider);

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: currentTab.value == 0
              ? AppBar(
                  backgroundColor: colorScheme.surface,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  title: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.surfaceContainer,
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuB_ed-ERBLeIla1t0aMV__AlEIejbPsS3SJzc6ti4ajOFy1QZ0wjxo3pLYNCPfYOi-gd6xM5cw98nK3Mwb5EetDGZjUTIl3mtEm7TTN0iP33f3TmsObpm51k5NYcOyoiDXNs1zcpxwhesPZOKC3YuuoLK9nCAMrp-IWsKDMCGlfWchVNeA19S2YwHvvPFgVeehel7LEG6KQiPce4RZRQLI-r7izPjQ9B3TaGiGYkwhimHRq6sdPWV-a8-cj_hJtKagbfFJ3ji6PxDhY',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        LocaleKeys.dashboard_title.tr(),
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_none_outlined,
                        color: colorScheme.primary,
                      ),
                    ),
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
                  ],
                )
              : null,
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildBodyForTab(
                context,
                currentTab.value,
                stateAsync,
                user.id,
                ref,
              ),
            ),
          ),
          floatingActionButton: currentTab.value == 0
              ? stateAsync.maybeWhen(
                  data: (state) {
                    if (state == null) return null;
                    return FloatingActionButton(
                      key: const Key('addExpenseFab'),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: const CircleBorder(),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AddExpenseDialog(flatId: state.flat.id),
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

  Widget _buildBodyForTab(
    BuildContext context,
    int tabIndex,
    AsyncValue<DashboardState?> stateAsync,
    String currentUserId,
    WidgetRef ref,
  ) {
    if (tabIndex != 0) {
      return Center(
        key: ValueKey('tab_$tabIndex'),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                tabIndex == 1
                    ? Icons.receipt_long
                    : tabIndex == 2
                    ? Icons.group
                    : Icons.settings,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                tabIndex == 1
                    ? LocaleKeys.dashboard_history_coming_soon.tr()
                    : tabIndex == 2
                    ? LocaleKeys.dashboard_admin_coming_soon.tr()
                    : LocaleKeys.dashboard_profile_coming_soon.tr(),
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return stateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(
          LocaleKeys.dashboard_error_loading_dashboard.tr(
            args: [err.toString()],
          ),
        ),
      ),

      data: (nullableState) {
        if (nullableState == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final state = nullableState;

        final cycle = state.activeCycle;
        final colorScheme = Theme.of(context);
        final textTheme = colorScheme.textTheme;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Header Section
              if (cycle != null) ...[
                Text(
                  cycle.monthName,
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
                          args: [state.flat.createdByName],
                        ),
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        cycle.status == 'published'
                            ? LocaleKeys.dashboard_status_published.tr()
                            : LocaleKeys.dashboard_status_draft.tr(),
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                BentoSummaryWidget(cycle: cycle),
              ],

              // Debt Matrix
              ref.watch(flatDebtsProvider(state.flat.id)).when(
                    data: (debts) => DebtMatrixWidget(
                      flatId: state.flat.id,
                      debts: debts,
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (err, stack) => Text(err.toString()),
                  ),

              // Itemized Expenses
              ItemizedExpensesWidget(
                expenses: state.expenses,
                currentUserId: currentUserId,
              ),

              // Recent Activity Feed
              ActivityFeedWidget(activities: state.activities),
            ],
          ),
        );
      },
    );
  }
}
