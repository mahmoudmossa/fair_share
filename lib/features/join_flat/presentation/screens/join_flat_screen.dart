import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/core/router/app_router.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_actions_provider.dart';
import '../widgets/join_flat_form_widget.dart';

@RoutePage()
class JoinFlatScreen extends HookConsumerWidget {
  const JoinFlatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: const JoinFlatFormWidget(),
          ),
        ),
      ),
    );
  }
}
