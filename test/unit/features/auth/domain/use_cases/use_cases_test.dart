import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';
import 'package:fair_share/features/auth/domain/repositories/auth_repository.dart';
import 'package:fair_share/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:fair_share/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:fair_share/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:fair_share/features/auth/domain/use_cases/auth_state_changes_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  group('SignInUseCase', () {
    late SignInUseCase useCase;
    const email = 'test@example.com';
    const password = 'password';
    const user = UserEntity(id: '123', email: email, displayName: 'Test User');

    setUp(() {
      useCase = SignInUseCase(mockAuthRepository);
    });

    test('should call signInWithEmailAndPassword on repository and return result', () async {
      when(() => mockAuthRepository.signInWithEmailAndPassword(email, password))
          .thenAnswer((_) async => const Right(user));

      final result = await useCase(email, password);

      expect(result, const Right(user));
      verify(() => mockAuthRepository.signInWithEmailAndPassword(email, password)).called(1);
    });
  });

  group('SignUpUseCase', () {
    late SignUpUseCase useCase;
    const email = 'test@example.com';
    const password = 'password';
    const user = UserEntity(id: '123', email: email, displayName: 'Test User');

    setUp(() {
      useCase = SignUpUseCase(mockAuthRepository);
    });

    test('should call signUpWithEmailAndPassword on repository and return result', () async {
      when(() => mockAuthRepository.signUpWithEmailAndPassword(email, password))
          .thenAnswer((_) async => const Right(user));

      final result = await useCase(email, password);

      expect(result, const Right(user));
      verify(() => mockAuthRepository.signUpWithEmailAndPassword(email, password)).called(1);
    });
  });

  group('SignOutUseCase', () {
    late SignOutUseCase useCase;

    setUp(() {
      useCase = SignOutUseCase(mockAuthRepository);
    });

    test('should call signOut on repository and return result', () async {
      when(() => mockAuthRepository.signOut()).thenAnswer((_) async => const Right(unit));

      final result = await useCase();

      expect(result, const Right(unit));
      verify(() => mockAuthRepository.signOut()).called(1);
    });
  });

  group('AuthStateChangesUseCase', () {
    late AuthStateChangesUseCase useCase;
    const user = UserEntity(id: '123', email: 'test@example.com', displayName: 'Test User');

    setUp(() {
      useCase = AuthStateChangesUseCase(mockAuthRepository);
    });

    test('should return authStateChanges stream from repository', () {
      final stream = Stream.value(user);
      when(() => mockAuthRepository.authStateChanges).thenAnswer((_) => stream);

      final result = useCase();

      expect(result, emits(user));
      verify(() => mockAuthRepository.authStateChanges).called(1);
    });
  });
}
