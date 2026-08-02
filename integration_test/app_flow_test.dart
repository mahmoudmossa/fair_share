import 'package:patrol/patrol.dart';

// Import your app's main file and providers
import 'package:fair_share/main.dart' as app;

// Import your Testing Scenarios and Fakes
import 'scenarios/login_test_scenario.dart';
import 'scenarios/flat_setup_test_scenario.dart';
import 'scenarios/dashboard_test_scenario.dart';
import 'scenarios/history_test_scenario.dart';
<<<<<<< HEAD
import 'scenarios/profile_test_scenario.dart';
=======
import 'scenarios/join_flat_test_scenario.dart';
>>>>>>> origin/main

void main() {
  // patrolTest = real device runner. It does NOT use pumpWidgetAndSettle.
  // Patrol boots the app via app.main() automatically.
  patrolTest(
      'Complete User Journey: Login -> Setup Flat -> Dashboard -> History -> Profile',
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
          next: HistoryTestScenario(
            $,
            next: ProfileTestScenario($, next: null),
          ),
        ),
      ),
    );

    // 3. Start the chain reaction
    await flow.startFlow();
  });

  patrolTest('Alternative User Journey: Login -> Join Flat with Invite Code', (
    $,
  ) async {
    app.main();
    await $.pumpAndSettle();

    final flow = LoginTestScenario(
      $,
      next: JoinFlatTestScenario($, next: null),
    );

    await flow.startFlow();
  });
}
