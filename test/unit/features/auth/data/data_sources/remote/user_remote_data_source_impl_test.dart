import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/features/auth/data/data_sources/remote/user_remote_data_source_impl.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;
  late UserRemoteDataSourceImpl dataSource;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    dataSource = UserRemoteDataSourceImpl(mockFirestore);
  });

  group('createUser', () {
    const user = UserEntity(id: '123', email: 'test@example.com', displayName: 'Test User');

    test('should call set on collection reference to save user info to firestore', () async {
      when(() => mockFirestore.collection(any())).thenReturn(mockCollectionReference);
      when(() => mockCollectionReference.doc(any())).thenReturn(mockDocumentReference);
      when(() => mockDocumentReference.set(any())).thenAnswer((_) async {});

      await dataSource.createUser(user);

      verify(() => mockFirestore.collection('users')).called(1);
      verify(() => mockCollectionReference.doc('123')).called(1);
      verify(() => mockDocumentReference.set({
            'id': '123',
            'email': 'test@example.com',
            'displayName': 'Test User',
          })).called(1);
    });
  });
}
