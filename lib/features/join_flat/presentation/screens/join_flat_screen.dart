import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fair_share/core/router/app_router.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:fair_share/features/join_flat/presentation/providers/join_flat_notifier_provider.dart';
import 'package:fair_share/core/modles/action_state.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
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
    ref.listen(joinFlatProvider, (prev, next) {
      next.maybeWhen(
        success: () {
          context.router.replace(const DashboardRoute());
        },
        failure: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.type.localizedMessage),
              backgroundColor: colorScheme.error,
            ),
          );
        },
        orElse: () {},
      );
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
