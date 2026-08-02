import 'package:flutter_test/flutter_test.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import '../support/base_test_scenario.dart';

class ProfileTestScenario extends BaseTestScenario {
  const ProfileTestScenario(super.$, {required super.next});

  @override
  Future<bool> waitAndCheckValid() async {
    await $(AppKeys.profile.profileTab).waitUntilVisible();
    await $(AppKeys.profile.profileTab).tap();
    await $.tester.pumpAndSettle();

    await $(AppKeys.profile.profileTitle).waitUntilVisible();
    return true;
  }

  @override
  Future<bool> run() async {
    await $(AppKeys.profile.editNameButton).waitUntilVisible();
    await $(AppKeys.profile.flatDetailsTile).waitUntilVisible();
    await $(AppKeys.profile.securityPrivacyTile).waitUntilVisible();
    await $(AppKeys.profile.logoutButton).waitUntilVisible();

    await $(AppKeys.profile.editNameButton).tap();
    await $.tester.pumpAndSettle();

    await $(AppKeys.profile.nameInputField).waitUntilVisible();
    await $(AppKeys.profile.cancelNameButton).waitUntilVisible();
    await $(AppKeys.profile.cancelNameButton).tap();
    await $.tester.pumpAndSettle();

    return true;
  }
}
