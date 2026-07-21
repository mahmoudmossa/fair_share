import 'package:auto_route/auto_route.dart';
import 'package:fair_share/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fair_share/core/modles/action_state.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import '../provider/flat_setup_provider.dart';
import '../provider/new_flat_provider.dart';
import '../widgets/setup_top_bar_widget.dart';
import '../widgets/setup_progress_bar_widget.dart';
import '../widgets/setup_bottom_bar_widget.dart';
import '../widgets/add_flat_name_step_widget.dart';
import '../widgets/add_members_step_widget.dart';
import '../widgets/add_costs_step_widget.dart';

@RoutePage()
class NewFlatScreen extends HookConsumerWidget {
  const NewFlatScreen({super.key});

  static const _totalSteps = 3;

  static const _steps = [
    AddFlatNameStepWidget(),
    AddMembersStepWidget(),
    AddCostsStepWidget(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = useState(0);
    final flatSetup = ref.watch(flatSetupProvider);
    final currentUser = ref.watch(authStateProvider).value;
    final submissionState = ref.watch(newFlatProvider);

    // Listen to submission status
    ref.listen<ActionState>(newFlatProvider, (previous, next) {
      next.maybeWhen(
        success: () {
          AutoRouter.of(context).replace(const DashboardRoute());
        },
        failure: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.type.name),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
        orElse: () {},
      );
    });

    final isLoaderVisible = submissionState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    void goNext() async {
      if (currentStep.value < _totalSteps - 1) {
        // Step 1: Flat Name Validation
        if (currentStep.value == 0 && flatSetup.name.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a name for your flat')),
          );
          return;
        }
        // Step 2: Members Validation
        if (currentStep.value == 1 && flatSetup.members.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please add at least one member to your household'),
            ),
          );
          return;
        }
        currentStep.value++;
      } else {
        // Step 3: Submission & Final Setup
        if (currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User session not found. Please log in again.'),
            ),
          );
          return;
        }

        // Validate that expenses are valid
        final invalidExpense = flatSetup.costs.any(
          (cost) => cost.title.trim().isEmpty || cost.amount <= 0.0,
        );
        if (invalidExpense) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please enter valid titles and amounts for all costs',
              ),
            ),
          );
          return;
        }

        final setupNotifier = ref.read(flatSetupProvider.notifier);

        // Generate invitation code
        setupNotifier.generateInvitationCode();

        // Submit final Flat payload to server
        final finalFlat = ref.read(flatSetupProvider);
        await ref.read(newFlatProvider.notifier).submitNewFlat(finalFlat);
      }
    }

    void goPrevious() {
      if (currentStep.value > 0) {
        currentStep.value--;
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SetupTopBar(onCancel: () => AutoRouter.of(context).maybePop()),
                SetupProgressBar(
                  currentStep: currentStep.value,
                  totalSteps: _totalSteps,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(currentStep.value),
                      child: _steps[currentStep.value],
                    ),
                  ),
                ),
                SetupBottomBar(
                  currentStep: currentStep.value,
                  totalSteps: _totalSteps,
                  onPrevious: goPrevious,
                  onNext: isLoaderVisible
                      ? () {}
                      : goNext, // Disable next button during submission
                ),
              ],
            ),
            if (isLoaderVisible)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
