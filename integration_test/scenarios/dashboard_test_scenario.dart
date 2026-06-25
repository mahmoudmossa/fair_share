import 'package:flutter/material.dart';
import '../support/base_test_scenario.dart';

class DashboardTestScenario extends BaseTestScenario {
  const DashboardTestScenario(super.$, {required super.next});

  @override
  Future<bool> waitAndCheckValid() async {
    // Wait until dashboard is visible with the flat name title
    await $('Baker Street 221B').waitUntilVisible();
    await $('Debt Matrix').waitUntilVisible();
    await $('Itemized Expenses').waitUntilVisible();
    await $('Recent Activity').waitUntilVisible();
    return true;
  }

  @override
  Future<bool> run() async {
    // 1. Settle one of the debts (debt1 is Rahoul -> Mahmoud)
    await $(const Key('settleButton_debt1')).tap();
    await $.tester.pumpAndSettle();

    // Verify the visual state updates to "Settled"
    await $('Settled').waitUntilVisible();

    // 2. Open Add Expense Dialog
    await $(const Key('addExpenseFab')).tap();
    await $.tester.pumpAndSettle();

    // Fill the dialog details
    await $(const Key('expenseTitleField')).enterText('Water Bill');
    await $(const Key('expenseAmountField')).enterText('80.00');
    
    // Save the expense
    await $(const Key('saveExpenseButton')).tap();
    await $.tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify the new expense is present in the list
    await $('Water Bill').waitUntilVisible();

    return true;
  }
}
