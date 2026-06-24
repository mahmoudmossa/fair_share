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
    await $(AppKeys.auth.toggleAuthModeButton).waitUntilVisible();
    return true;
  }

  @override
  Future<bool> run() async {
    // 1. Toggle to Create Account Mode
    await $(AppKeys.auth.toggleAuthModeButton).tap();
    await $.tester.pumpAndSettle();

    // Verify Confirm Password field is visible
    await $(AppKeys.auth.confirmPasswordField).waitUntilVisible();
    await $(AppKeys.auth.signUpButton).waitUntilVisible();

    // 2. Enter non-matching passwords to test validation ("not same check again")
    await $(AppKeys.auth.emailField).enterText('test@example.com');
    await $(AppKeys.auth.passwordField).enterText('password123');
    await $(AppKeys.auth.confirmPasswordField).enterText('different123');
    
    // Tap sign up and pump to see validation error SnackBar
    await $(AppKeys.auth.signUpButton).tap();
    await $.tester.pumpAndSettle();

    // 3. Enter matching passwords to complete sign up
    await $(AppKeys.auth.confirmPasswordField).enterText('password123');
    await $(AppKeys.auth.signUpButton).tap();
    await $.tester.pumpAndSettle();

    return true;
  }
}
