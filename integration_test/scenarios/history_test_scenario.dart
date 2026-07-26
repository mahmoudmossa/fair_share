import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import '../support/base_test_scenario.dart';

class HistoryTestScenario extends BaseTestScenario {
  const HistoryTestScenario(super.$, {required super.next});

  @override
  Future<bool> waitAndCheckValid() async {
    // Navigate to the History tab (index 1 in bottom nav)
    await $(AppKeys.history.historyNavTab).waitUntilVisible();
    await $(AppKeys.history.historyNavTab).tap();
    await $.tester.pumpAndSettle();

    // Verify the History screen title is visible
    await $('Expense History').waitUntilVisible();
    return true;
  }

  @override
  Future<bool> run() async {
    // Wait for the history table to load (at least the header row)
    await $('Month').waitUntilVisible();
    await $('Total').waitUntilVisible();
    await $('My Share').waitUntilVisible();

    // Tap the first available history row (if any locked months exist)
    // The empty rows are also tappable and navigate to the detail screen
    final firstRow = $(find.byType(InkWell)).first;
    if (firstRow.exists) {
      await firstRow.tap();
      await $.tester.pumpAndSettle();

      // Verify Month Detail screen is shown
      await $(AppKeys.history.monthDetailBackButton).waitUntilVisible();
      await $(AppKeys.history.monthDetailTitle).waitUntilVisible();

      // Navigate back
      await $(AppKeys.history.monthDetailBackButton).tap();
      await $.tester.pumpAndSettle();
    }

    return true;
  }
}
