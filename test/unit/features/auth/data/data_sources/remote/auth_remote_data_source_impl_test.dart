import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/features/auth/data/data_sources/remote/auth_remote_data_source_impl.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    dataSource = AuthRemoteDataSourceImpl(mockFirebaseAuth);
  });

  group('authStateChanges', () {
    test('should emit stream of user changes from firebase auth', () {
      final mockUser = MockUser();
      final stream = Stream.value(mockUser);
      when(() => mockFirebaseAuth.authStateChanges()).thenAnswer((_) => stream);

      final result = dataSource.authStateChanges;

      expect(result, emits(mockUser));
      verify(() => mockFirebaseAuth.authStateChanges()).called(1);
    });
  });

  group('signInWithEmail', () {
    test('should call signInWithEmailAndPassword on firebase auth and return credential', () async {
      final mockCredential = MockUserCredential();
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          )).thenAnswer((_) async => mockCredential);

      final result = await dataSource.signInWithEmail('test@example.com', 'password');

      expect(result, mockCredential);
      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          )).called(1);
    });
  });

  group('signUpWithEmail', () {
    test('should call createUserWithEmailAndPassword on firebase auth and return credential', () async {
      final mockCredential = MockUserCredential();
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          )).thenAnswer((_) async => mockCredential);

      final result = await dataSource.signUpWithEmail('test@example.com', 'password');

      expect(result, mockCredential);
      verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password',
          )).called(1);
    });
  });

  group('signOut', () {
    test('should call signOut on firebase auth', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await dataSource.signOut();

      verify(() => mockFirebaseAuth.signOut()).called(1);
    });
  });
}
