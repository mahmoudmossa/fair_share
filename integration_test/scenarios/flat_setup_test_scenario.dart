import 'package:flutter/material.dart';
import '../support/base_test_scenario.dart';

class FlatSetupTestScenario extends BaseTestScenario {
  const FlatSetupTestScenario(super.$, {required super.next});

  @override
  Future<bool> waitAndCheckValid() async {
    // Wait until join flat screen is visible
    await $('Join your Flat').waitUntilVisible();
    await $(const Key('toggleCreateFlatModeButton')).waitUntilVisible();
    return true;
  }

  @override
  Future<bool> run() async {
    // 1. Toggle to create flat mode
    await $(const Key('toggleCreateFlatModeButton')).tap();
    await $.tester.pumpAndSettle();

    // Verify Create Flat UI is visible
    await $('Create a new Flat').waitUntilVisible();
    await $(const Key('flatNameField')).waitUntilVisible();

    // 2. Enter flat name and tap Create
    await $(const Key('flatNameField')).enterText('Baker Street 221B');
    await $(const Key('createFlatButton')).tap();
    // Allow transit and database seeding
    await $.tester.pumpAndSettle(const Duration(seconds: 1));

    return true;
  }
}
