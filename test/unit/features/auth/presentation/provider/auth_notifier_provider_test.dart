import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';
import 'package:fair_share/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:fair_share/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_notifier_provider.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}
class MockSignOutUseCase extends Mock implements SignOutUseCase {}

void main() {
  late MockSignInUseCase mockSignInUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late ProviderContainer container;

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
    mockSignOutUseCase = MockSignOutUseCase();
    
    container = ProviderContainer(
      overrides: [
        signInUseCaseProvider.overrideWith((ref) => mockSignInUseCase),
        signOutUseCaseProvider.overrideWith((ref) => mockSignOutUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('initial state', () {
    test('should be ActionInitial', () {
      final state = container.read(authProvider);
      expect(state, const ActionInitial<UserEntity?>());
    });
  });

  group('signIn', () {
    const email = 'test@example.com';
    const password = 'password';
    const user = UserEntity(id: '123', email: email, displayName: 'Test User');

    test('should emit [ActionLoading, ActionSuccess] when sign in is successful', () async {
      when(() => mockSignInUseCase(email, password))
          .thenAnswer((_) async => const Right(user));

      final notifier = container.read(authProvider.notifier);
      
      final states = <ActionState<UserEntity?>>[];
      container.listen<ActionState<UserEntity?>>(
        authProvider,
        (previous, next) => states.add(next),
        fireImmediately: false,
      );

      await notifier.signIn(email, password);

      expect(states, [
        const ActionLoading<UserEntity?>(),
        const ActionSuccess<UserEntity?>(user),
      ]);
      verify(() => mockSignInUseCase(email, password)).called(1);
    });

    test('should emit [ActionLoading, ActionError] when sign in fails', () async {
      final exception = Exception('Invalid credentials');
      when(() => mockSignInUseCase(email, password))
          .thenAnswer((_) async => Left(exception));

      final notifier = container.read(authProvider.notifier);
      
      final states = <ActionState<UserEntity?>>[];
      container.listen<ActionState<UserEntity?>>(
        authProvider,
        (previous, next) => states.add(next),
        fireImmediately: false,
      );

      await notifier.signIn(email, password);

      expect(states, [
        const ActionLoading<UserEntity?>(),
        ActionError<UserEntity?>(exception),
      ]);
      verify(() => mockSignInUseCase(email, password)).called(1);
    });
  });

  group('signOut', () {
    test('should emit [ActionLoading, ActionSuccess(null)] when sign out is successful', () async {
      when(() => mockSignOutUseCase()).thenAnswer((_) async => const Right(unit));

      final notifier = container.read(authProvider.notifier);
      
      final states = <ActionState<UserEntity?>>[];
      container.listen<ActionState<UserEntity?>>(
        authProvider,
        (previous, next) => states.add(next),
        fireImmediately: false,
      );

      await notifier.signOut();

      expect(states, [
        const ActionLoading<UserEntity?>(),
        const ActionSuccess<UserEntity?>(null),
      ]);
      verify(() => mockSignOutUseCase()).called(1);
    });

    test('should emit [ActionLoading, ActionError] when sign out fails', () async {
      final exception = Exception('Network error');
      when(() => mockSignOutUseCase()).thenAnswer((_) async => Left(exception));

      final notifier = container.read(authProvider.notifier);
      
      final states = <ActionState<UserEntity?>>[];
      container.listen<ActionState<UserEntity?>>(
        authProvider,
        (previous, next) => states.add(next),
        fireImmediately: false,
      );

      await notifier.signOut();

      expect(states, [
        const ActionLoading<UserEntity?>(),
        ActionError<UserEntity?>(exception),
      ]);
      verify(() => mockSignOutUseCase()).called(1);
    });
  });
}
