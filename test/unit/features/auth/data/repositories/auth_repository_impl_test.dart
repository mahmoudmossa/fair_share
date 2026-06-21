import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:fair_share/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockUserCredential extends Mock implements firebase.UserCredential {}
class MockUser extends Mock implements firebase.User {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemoteDataSource);
  });

  group('authStateChanges', () {
    test('should map firebase user stream to domain user entity stream', () {
      final mockFirebaseUser = MockUser();
      when(() => mockFirebaseUser.uid).thenReturn('123');
      when(() => mockFirebaseUser.email).thenReturn('test@example.com');
      when(() => mockFirebaseUser.displayName).thenReturn('Test User');

      when(() => mockRemoteDataSource.authStateChanges)
          .thenAnswer((_) => Stream.fromIterable([mockFirebaseUser, null]));

      final expectedEntities = [
        const UserEntity(id: '123', email: 'test@example.com', displayName: 'Test User'),
        null,
      ];

      expect(repository.authStateChanges, emitsInOrder(expectedEntities));
    });
  });

  group('signInWithEmailAndPassword', () {
    const email = 'test@example.com';
    const password = 'password';

    test('should return Right(UserEntity) when call to remote data source is successful', () async {
      final mockFirebaseUser = MockUser();
      when(() => mockFirebaseUser.uid).thenReturn('123');
      when(() => mockFirebaseUser.email).thenReturn(email);
      when(() => mockFirebaseUser.displayName).thenReturn('Test User');

      final mockCredential = MockUserCredential();
      when(() => mockCredential.user).thenReturn(mockFirebaseUser);

      when(() => mockRemoteDataSource.signInWithEmail(email, password))
          .thenAnswer((_) async => mockCredential);

      final result = await repository.signInWithEmailAndPassword(email, password);

      expect(
        result,
        const Right(UserEntity(id: '123', email: email, displayName: 'Test User')),
      );
      verify(() => mockRemoteDataSource.signInWithEmail(email, password)).called(1);
    });

    test('should return Left(Exception) when call to remote data source throws exception', () async {
      final exception = Exception('Auth failed');
      when(() => mockRemoteDataSource.signInWithEmail(email, password)).thenThrow(exception);

      final result = await repository.signInWithEmailAndPassword(email, password);

      expect(result, Left(exception));
      verify(() => mockRemoteDataSource.signInWithEmail(email, password)).called(1);
    });
  });

  group('signUpWithEmailAndPassword', () {
    const email = 'test@example.com';
    const password = 'password';

    test('should return Right(UserEntity) when sign up is successful', () async {
      final mockFirebaseUser = MockUser();
      when(() => mockFirebaseUser.uid).thenReturn('123');
      when(() => mockFirebaseUser.email).thenReturn(email);
      when(() => mockFirebaseUser.displayName).thenReturn('Test User');

      final mockCredential = MockUserCredential();
      when(() => mockCredential.user).thenReturn(mockFirebaseUser);

      when(() => mockRemoteDataSource.signUpWithEmail(email, password))
          .thenAnswer((_) async => mockCredential);

      final result = await repository.signUpWithEmailAndPassword(email, password);

      expect(
        result,
        const Right(UserEntity(id: '123', email: email, displayName: 'Test User')),
      );
      verify(() => mockRemoteDataSource.signUpWithEmail(email, password)).called(1);
    });

    test('should return Left(Exception) when sign up throws exception', () async {
      final exception = Exception('Sign up failed');
      when(() => mockRemoteDataSource.signUpWithEmail(email, password)).thenThrow(exception);

      final result = await repository.signUpWithEmailAndPassword(email, password);

      expect(result, Left(exception));
      verify(() => mockRemoteDataSource.signUpWithEmail(email, password)).called(1);
    });
  });

  group('signOut', () {
    test('should return Right(unit) when sign out is successful', () async {
      when(() => mockRemoteDataSource.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result, const Right(unit));
      verify(() => mockRemoteDataSource.signOut()).called(1);
    });

    test('should return Left(Exception) when sign out throws exception', () async {
      final exception = Exception('Sign out failed');
      when(() => mockRemoteDataSource.signOut()).thenThrow(exception);

      final result = await repository.signOut();

      expect(result, Left(exception));
      verify(() => mockRemoteDataSource.signOut()).called(1);
    });
  });
}
