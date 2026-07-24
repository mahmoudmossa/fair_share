import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/features/new_flat/domain/repositories/flat_repository.dart';
import 'package:fair_share/features/new_flat/presentation/provider/new_flat_repository_provider.dart';
import 'package:fair_share/features/new_flat/presentation/screens/new_flat_screen.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../shared/pump_widget.dart';
import '../../../../../shared/setup_widget_test_environment.dart';

class MockFlatRepository extends Mock implements FlatRepository {}

void main() {
  late MockFlatRepository mockFlatRepository;
  setupWidgetTestEnvironment();

  // setUpAll(() {
  //   final jsonContent = File('assets/translations/en.json').readAsStringSync();
  //   final Map<String, dynamic> translationsMap = jsonDecode(jsonContent);
  //   Localization.load(
  //     const Locale('en'),
  //     translations: Translations(translationsMap),
  //   );
  // });

  setUp(() {
    mockFlatRepository = MockFlatRepository();
  });

  Future<void> pumpWidget(WidgetTester tester) async =>
      await tester.pumpLocalizedWidget(
        NewFlatScreen(),
        overrides: [
          newFlatRepositoryProvider.overrideWithValue(mockFlatRepository),
          authStateProvider.overrideWith((ref) => Stream.value(null)),
        ],
      );

  Future<void> completeStep1(
    WidgetTester tester, {
    String flatName = 'My WG',
  }) async {
    final flatNameField = find.byKey(AppKeys.newFlat.flatNameField);
    await tester.enterText(flatNameField, flatName);
    await tester.pump();

    final continueBttn = find.byKey(AppKeys.newFlat.continueButton);
    await tester.tap(continueBttn);
    await tester.pumpAndSettle();
  }

  Future<void> addMember(WidgetTester tester, String memberName) async {
    final memberNameField = find.byKey(AppKeys.newFlat.memberNameField);
    await tester.enterText(memberNameField, memberName);
    await tester.pump();

    final addMemberBttn = find.byKey(AppKeys.newFlat.addMemberButton);
    await tester.tap(addMemberBttn);
    await tester.pumpAndSettle();
  }

  group('NewFlatScreen tests', () {
    testWidgets('step 1 should have flat name input field', (tester) async {
      await pumpWidget(tester);
      await tester.pumpAndSettle();

      await completeStep1(tester, flatName: 'flatName');

      expect(find.text('Who lives here with you?'), findsOneWidget);
      expect(find.text('Step 2 of 3'), findsOneWidget);
    });

    testWidgets('step 2 should add member and transition to step 3', (
      tester,
    ) async {
      await pumpWidget(tester);
      await tester.pumpAndSettle();

      await completeStep1(tester);
      await addMember(tester, 'Creator Name');
      await addMember(tester, 'flatmate Name');

      final continueBttn = find.byKey(AppKeys.newFlat.continueButton);
      await tester.tap(continueBttn);
      await tester.pumpAndSettle();

      final expectedText = find.byKey(AppKeys.newFlat.finishButton);
      expect(expectedText, findsOneWidget);
    });
  });
}
