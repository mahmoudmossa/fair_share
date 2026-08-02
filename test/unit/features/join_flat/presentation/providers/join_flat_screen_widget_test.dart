import 'package:auto_route/auto_route.dart';
import 'package:fair_share/core/router/app_router.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import 'package:fair_share/features/join_flat/domain/repositories/join_flat_repository.dart';
import 'package:fair_share/features/join_flat/presentation/providers/join_flat_repository_provider.dart';
import 'package:fair_share/features/join_flat/presentation/screens/join_flat_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../shared/pump_widget.dart';
import '../../../../../shared/setup_widget_test_environment.dart';

class MockJoinFlatRepository extends Mock implements JoinFlatRepository {}
class MockStackRouter extends Mock implements StackRouter {}

void main() {
  late MockJoinFlatRepository mockRepository;
  late MockStackRouter mockRouter;
  setupWidgetTestEnvironment();

  setUpAll(() {
    registerFallbackValue(const DashboardRoute());
  });

  setUp(() {
    mockRepository = MockJoinFlatRepository();
    mockRouter = MockStackRouter();
    when(() => mockRouter.replace(any())).thenAnswer((_) async => null);
  });

  const testUser = UserEntity(
    id: 'user-123',
    email: 'test@example.com',
    displayName: 'Max',
  );

  Future<void> pumpWidget(WidgetTester tester) async {
    await tester.pumpLocalizedWidget(
      StackRouterScope(
        controller: mockRouter,
        stateHash: 0,
        child: const JoinFlatScreen(),
      ),
      overrides: [
        joinFlatRepositoryProvider.overrideWithValue(mockRepository),
        authStateProvider.overrideWith((ref) => Stream.value(testUser)),
      ],
    );
  }

  group('JoinFlatScreen Widget Tests', () {
    testWidgets('should render PIN fields and Join button', (tester) async {
      await pumpWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byKey(AppKeys.joinFlat.joinFlatView), findsOneWidget);
      expect(find.byKey(AppKeys.joinFlat.joinFlatButton), findsOneWidget);
      for (int i = 0; i < 6; i++) {
        expect(find.byKey(AppKeys.joinFlat.pinDigitField(i)), findsOneWidget);
      }
    });

    testWidgets('should call JoinFlatUseCase on repository when 6 digits are typed and join tapped', (tester) async {
      when(() => mockRepository.joinFlatWithCode(
            inviteCode: '123456',
            userId: testUser.id,
            userEmail: testUser.email,
          )).thenAnswer((_) async => {});

      await pumpWidget(tester);
      await tester.pumpAndSettle();

      // Enter digits
      for (int i = 0; i < 6; i++) {
        await tester.enterText(find.byKey(AppKeys.joinFlat.pinDigitField(i)), (i + 1).toString());
      }
      await tester.pump();

      // Tap join
      await tester.tap(find.byKey(AppKeys.joinFlat.joinFlatButton));
      await tester.pump();

      verify(() => mockRepository.joinFlatWithCode(
            inviteCode: '123456',
            userId: testUser.id,
            userEmail: testUser.email,
          )).called(1);
    });
  });
}
