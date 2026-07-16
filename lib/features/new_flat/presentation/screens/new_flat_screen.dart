import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

    void goNext() {
      if (currentStep.value < _totalSteps - 1) {
        currentStep.value++;
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
        child: Column(
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
              onNext: goNext,
            ),
          ],
        ),
      ),
    );
  }
}
