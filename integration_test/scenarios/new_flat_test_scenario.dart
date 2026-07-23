import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/features/new_flat/presentation/widgets/add_members/member_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/base_test_scenario.dart';

class NewFlatTestScenario extends BaseTestScenario {
  NewFlatTestScenario(super.$, {super.next});
  @override
  Future<bool> run() async {
    // step 1
    await $(AppKeys.newFlat.flatNameField).enterText('flat name');
    await $(AppKeys.newFlat.continueButton).tap();
    await $.pumpAndSettle();

    // step 2
    // Step 2: Add Creator Name
    await $(AppKeys.newFlat.memberNameField).enterText('Mahmoud');
    await $(AppKeys.newFlat.addMemberButton).tap();
    await $.pumpAndSettle();
    // Step 2: Add Roommate
    await $(AppKeys.newFlat.memberNameField).enterText('Sarah');
    await $(AppKeys.newFlat.addMemberButton).tap();
    await $.pumpAndSettle();
    expect($('Mahmoud'), findsOneWidget);
    expect($('Sarah'), findsOneWidget);
    await $(MemberCard).containing('Sarah').$(Icons.delete_outline).tap();
    await $.pumpAndSettle();
    expect($('Sarah'), findsNothing);
    await $(AppKeys.newFlat.continueButton).tap();
    await $.pumpAndSettle();

    // step 3
    await $(AppKeys.newFlat.costTitle).enterText('internet');
    await $(AppKeys.newFlat.costAmount).enterText('100');
    await $(AppKeys.newFlat.payedByDropdown).;
    await $(AppKeys.newFlat.costTitle).enterText('internet');
    
    return true;
  }

  @override
  Future<bool> waitAndCheckValid() {
    // TODO: implement waitAndCheckValid
    throw UnimplementedError();
  }
}
