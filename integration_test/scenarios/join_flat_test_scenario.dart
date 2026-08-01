import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import '../support/base_test_scenario.dart';

class JoinFlatTestScenario extends BaseTestScenario {
  const JoinFlatTestScenario(super.$, {required super.next});

  @override
  Future<bool> waitAndCheckValid() async {
    await $(AppKeys.joinFlat.goToJoinFlatButton).waitUntilVisible();
    return true;
  }

  @override
  Future<bool> run() async {
    // 1. Tap Join Flat card to route to Join Flat Screen
    await $(AppKeys.joinFlat.goToJoinFlatButton).tap();
    await $.tester.pumpAndSettle();

    // Verify Join Flat Screen UI is visible
    await $(AppKeys.joinFlat.joinFlatView).waitUntilVisible();

    // 2. Enter an invalid 6-digit code (e.g., 999999) to test failure
    for (int i = 0; i < 6; i++) {
      await $(AppKeys.joinFlat.pinDigitField(i)).enterText('9');
    }
    await $.tester.pumpAndSettle();

    // 3. Tap Join Button
    await $(AppKeys.joinFlat.joinFlatButton).tap();
    await $.tester.pumpAndSettle(const Duration(seconds: 2));

    // 4. Verify that error SnackBar is shown (since 999999 is invalid)
    expect($(SnackBar), findsOneWidget);

    return true;
  }
}
