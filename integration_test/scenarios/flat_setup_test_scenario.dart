import 'package:flutter/material.dart';
import '../support/base_test_scenario.dart';

class FlatSetupTestScenario extends BaseTestScenario {
  const FlatSetupTestScenario(super.$, {required super.next});

  @override
  Future<bool> waitAndCheckValid() async {
    // Wait until options selection screen is visible
    await $(const Key('goToCreateFlatButton')).waitUntilVisible();
    await $(const Key('goToJoinFlatButton')).waitUntilVisible();
    return true;
  }

  @override
  Future<bool> run() async {
    // 1. Tap Create Flat card to route to setup wizard
    await $(const Key('goToCreateFlatButton')).tap();
    await $.tester.pumpAndSettle();

    // Verify Create Flat step 1 UI is visible
    await $('Create a new Flat').waitUntilVisible();
    await $(const Key('flatNameField')).waitUntilVisible();

    // 2. Step 1: Enter flat name and tap Continue
    await $(const Key('flatNameField')).enterText('Baker Street 221B');
    await $(const Key('newFlatContinueButton')).tap();
    await $.tester.pumpAndSettle();

    // 3. Step 2: Add creator's name and a flatmate
    await $(const Key('newFlatMemberNameField')).enterText('Sherlock');
    await $(const Key('newFlatAddMemberButton')).tap();
    await $.tester.pumpAndSettle();

    await $(const Key('newFlatMemberNameField')).enterText('Watson');
    await $(const Key('newFlatAddMemberButton')).tap();
    await $.tester.pumpAndSettle();

    await $(const Key('newFlatContinueButton')).tap();
    await $.tester.pumpAndSettle();

    // 4. Step 3: Finish setup
    await $(const Key('newFlatFinishButton')).tap();
    // Allow transit and database seeding
    await $.tester.pumpAndSettle(const Duration(seconds: 2));

    return true;
  }
}
