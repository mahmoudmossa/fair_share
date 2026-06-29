import 'package:patrol/patrol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

// Import your app's main file and providers
import 'package:fair_share/main.dart' as app;
import 'package:fair_share/features/auth/data/repositories/auth_repository_impl.dart';

// Import your Testing Scenarios and Fakes
import 'support/fake_auth_repository.dart';
import 'scenarios/login_test_scenario.dart';
import 'scenarios/flat_setup_test_scenario.dart';
import 'scenarios/dashboard_test_scenario.dart';

void main() {
  // patrolTest = real device runner. It does NOT use pumpWidgetAndSettle.
  // Patrol boots the app via app.main() automatically.
  patrolTest(
    'Complete User Journey: Login -> Setup Flat -> Dashboard',
    ($) async {
      // 1. Boot the real app on the device.
      // Patrol will call app.main() which initialises Firebase etc.
      app.main(); // main() returns void, cannot be awaited
      await $.pumpAndSettle();

      // 2. Setup the Chain of Responsibility (Flow Definition)
      final flow = LoginTestScenario(
        $,
        next: FlatSetupTestScenario(
          $,
          next: DashboardTestScenario(
            $,
            next: null,
          ),
        ),
      );

      // 3. Start the chain reaction
      await flow.startFlow();
    },
  );
}
