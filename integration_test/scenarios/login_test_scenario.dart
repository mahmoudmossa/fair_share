import 'package:fair_share/core/constants/app_keys.dart';
import '../support/base_test_scenario.dart';

class LoginTestScenario extends BaseTestScenario {
  const LoginTestScenario(super.$, {required super.next});

  @override
  Future<bool> waitAndCheckValid() async {
    // Wait until the form fields on the LoginScreen are visible using AppKeys
    await $(AppKeys.auth.emailField).waitUntilVisible();
    await $(AppKeys.auth.passwordField).waitUntilVisible();
    await $(AppKeys.auth.signInButton).waitUntilVisible();
    return true;
  }

  @override
  Future<bool> run() async {
    // Fill in the form and tap the Sign In button
    await $(AppKeys.auth.emailField).enterText('test@example.com');
    await $(AppKeys.auth.passwordField).enterText('password123');
    await $(AppKeys.auth.signInButton).tap();
    await $.tester.pumpAndSettle();
    return true;
  }
}
