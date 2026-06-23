import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patrol/patrol.dart';
import 'package:fair_share/main.dart' as app;
import 'package:fair_share/features/auth/data/repositories/auth_repository_impl.dart';
import 'support/fake_auth_repository.dart';
import 'scenarios/login_test_scenario.dart';

void main() {
  patrolWidgetTest(
    'Initial App Module Test Flow',
    ($) async {
      final fakeAuthRepository = FakeAuthRepository();

      // Pump the main app with ProviderScope overriding real Firebase Auth repository
      await $.pumpWidgetAndSettle(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWith((ref) => fakeAuthRepository),
          ],
          child: app.MainApp(),
        ),
      );

      // Setup the scenario flow (chain of responsibility) with only Login scenario
      final loginScenario = LoginTestScenario($, next: null);

      // Execute the test flow starting from the Login Screen
      await loginScenario.startFlow();
    },
  );
}
