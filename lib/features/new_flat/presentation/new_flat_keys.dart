import 'package:flutter/material.dart';

class NewFlatKeys {
  const NewFlatKeys();

  // Setup flow navigation
  final backButton = const Key('newFlatBackButton');
  final cancelButton = const Key('newFlatCancelButton');
  final previousButton = const Key('newFlatPreviousButton');
  final continueButton = const Key('newFlatContinueButton');
  final finishButton = const Key('newFlatFinishButton');

  // Step 1 – Name flat
  final flatNameField = const Key('newFlatFlatNameField');

  // Step 2 – Add members
  final memberNameField = const Key('newFlatMemberNameField');
  final deleteMemberButton = const Key('deleteMemberButton');
  final addMemberButton = const Key('newFlatAddMemberButton');

  // Step 3 – Add costs
  final addCostButton = const Key('newFlatAddCostButton');
  final costTitle = const Key('costTitle');
  final costAmount = const Key('costAmount');
  final payedByDropdown = const Key('payedByDropdown');
  final recurringTypeDropdown = const Key('recurringTypeDropdown');
  final addCost = const Key('addCost');
}
