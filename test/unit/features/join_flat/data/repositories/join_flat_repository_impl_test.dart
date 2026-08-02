import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:fair_share/features/join_flat/data/data_sources/remote/join_flat_remote_data_source.dart';
import 'package:fair_share/features/join_flat/data/repositories/join_flat_repository_impl.dart';
import 'package:fair_share/features/join_flat/data/models/invitation_dto.dart';

class MockJoinFlatRemoteDataSource extends Mock implements JoinFlatRemoteDataSource {}
class MockAppErrorHandler extends Mock implements AppErrorHandler {}
class MockFirebaseErrorMapper extends Mock implements FirebaseErrorMapper {}

void main() {
  late MockJoinFlatRemoteDataSource mockRemoteDataSource;
  late MockAppErrorHandler mockErrorHandler;
  late MockFirebaseErrorMapper mockErrorMapper;
  late JoinFlatRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockJoinFlatRemoteDataSource();
    mockErrorHandler = MockAppErrorHandler();
    mockErrorMapper = MockFirebaseErrorMapper();
    repository = JoinFlatRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      errorHandler: mockErrorHandler,
      errorMapper: mockErrorMapper,
    );
  });

  const inviteCode = 'FAIR89';
  const flatId = 'flat-123';
  const userId = 'user-123';
  const userEmail = 'test@example.com';
  const testInvitation = InvitationDto(
    inviteCode: inviteCode,
    flatId: flatId,
    memberId: 'member-123',
    memberName: 'Watson',
    status: 'pending',
  );

  group('JoinFlatRepositoryImpl Unit Tests', () {
    test('should succeed when remote data source calls succeed', () async {
      // Arrange
      when(() => mockRemoteDataSource.findInvitationByCode(inviteCode))
          .thenAnswer((_) async => testInvitation);
      when(() => mockRemoteDataSource.executeJoinFlatTransaction(
            inviteCode: inviteCode,
            flatId: flatId,
            memberId: 'member-123',
            userId: userId,
            userEmail: userEmail,
            userName: 'Watson',
          )).thenAnswer((_) async => {});

      // Act
      await repository.joinFlatWithCode(
        inviteCode: inviteCode,
        userId: userId,
        userEmail: userEmail,
      );

      // Assert
      verify(() => mockRemoteDataSource.findInvitationByCode(inviteCode)).called(1);
      verify(() => mockRemoteDataSource.executeJoinFlatTransaction(
            inviteCode: inviteCode,
            flatId: flatId,
            memberId: 'member-123',
            userId: userId,
            userEmail: userEmail,
            userName: 'Watson',
          )).called(1);
      verifyZeroInteractions(mockErrorHandler);
      verifyZeroInteractions(mockErrorMapper);
    });

    test('should throw alreadyClaimed ServerFailure when invitation is not pending', () async {
      // Arrange
      const claimedInvitation = InvitationDto(
        inviteCode: inviteCode,
        flatId: flatId,
        memberId: 'member-123',
        memberName: 'Watson',
        status: 'used',
      );
      when(() => mockRemoteDataSource.findInvitationByCode(inviteCode))
          .thenAnswer((_) async => claimedInvitation);

      // Act & Assert
      expect(
        () => repository.joinFlatWithCode(
          inviteCode: inviteCode,
          userId: userId,
          userEmail: userEmail,
        ),
        throwsA(isA<ServerFailure>().having(
          (f) => f.type,
          'type',
          ServerFailureType.alreadyClaimed,
        )),
      );
    });

    test('should throw invalidInvite ServerFailure when lookup returns not-found', () async {
      // Arrange
      final exception = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
      );
      when(() => mockRemoteDataSource.findInvitationByCode(inviteCode))
          .thenThrow(exception);
      when(() => mockErrorHandler.handle(
            exception,
            any(),
            context: any(named: 'context'),
          )).thenAnswer((_) async => {});

      // Act & Assert
      expect(
        () => repository.joinFlatWithCode(
          inviteCode: inviteCode,
          userId: userId,
          userEmail: userEmail,
        ),
        throwsA(isA<ServerFailure>().having(
          (f) => f.type,
          'type',
          ServerFailureType.invalidInvite,
        )),
      );
    });

    test('should handle FirebaseException, call error handler, and map to Failure', () async {
      // Arrange
      final exception = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
      );
      final failure = ServerFailure(ServerFailureType.permissionDenied);

      when(() => mockRemoteDataSource.findInvitationByCode(inviteCode))
          .thenThrow(exception);
      when(() => mockErrorMapper.mapException(exception)).thenReturn(failure);
      when(() => mockErrorHandler.handle(
            exception,
            any(),
            context: any(named: 'context'),
          )).thenAnswer((_) async => {});

      // Act & Assert
      expect(
        () => repository.joinFlatWithCode(
          inviteCode: inviteCode,
          userId: userId,
          userEmail: userEmail,
        ),
        throwsA(equals(failure)),
      );

      verify(() => mockRemoteDataSource.findInvitationByCode(inviteCode)).called(1);
      verify(() => mockErrorHandler.handle(
            exception,
            any(),
            context: 'JoinFlatRepositoryImpl.joinFlatWithCode',
          )).called(1);
      verify(() => mockErrorMapper.mapException(exception)).called(1);
    });

    test('should handle general exceptions, call error handler, and throw unknown ServerFailure', () async {
      // Arrange
      final exception = Exception('Unknown error');

      when(() => mockRemoteDataSource.findInvitationByCode(inviteCode))
          .thenThrow(exception);
      when(() => mockErrorHandler.handle(
            exception,
            any(),
            context: any(named: 'context'),
          )).thenAnswer((_) async => {});

      // Act & Assert
      expect(
        () => repository.joinFlatWithCode(
          inviteCode: inviteCode,
          userId: userId,
          userEmail: userEmail,
        ),
        throwsA(isA<ServerFailure>().having(
          (f) => f.type,
          'type',
          ServerFailureType.unknown,
        )),
      );

      verify(() => mockRemoteDataSource.findInvitationByCode(inviteCode)).called(1);
      verify(() => mockErrorHandler.handle(
            exception,
            any(),
            context: 'JoinFlatRepositoryImpl.joinFlatWithCode',
          )).called(1);
      verifyZeroInteractions(mockErrorMapper);
    });
  });
}
