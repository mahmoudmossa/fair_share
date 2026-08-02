import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:fair_share/features/join_flat/domain/repositories/join_flat_repository.dart';
import 'package:fair_share/features/join_flat/domain/use_cases/join_flat_use_case.dart';

class MockJoinFlatRepository extends Mock implements JoinFlatRepository {}

void main() {
  late MockJoinFlatRepository mockRepository;
  late JoinFlatUseCase joinFlatUseCase;

  setUp(() {
    mockRepository = MockJoinFlatRepository();
    joinFlatUseCase = JoinFlatUseCase(mockRepository);
  });

  const inviteCode = 'FAIR89';
  const userId = 'user-123';
  const userEmail = 'test@example.com';

  group('JoinFlatUseCase Unit Tests', () {
    test('should normalize code to uppercase and call joinFlatWithCode on repository', () async {
      // Arrange
      when(() => mockRepository.joinFlatWithCode(
            inviteCode: 'FAIR89',
            userId: userId,
            userEmail: userEmail,
          )).thenAnswer((_) async => {});

      // Act
      await joinFlatUseCase(
        inviteCode: 'fair89', // lowercase
        userId: userId,
        userEmail: userEmail,
      );

      // Assert
      verify(() => mockRepository.joinFlatWithCode(
            inviteCode: 'FAIR89',
            userId: userId,
            userEmail: userEmail,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw a ServerFailure if the clean code is not 6 characters', () async {
      // Act & Assert
      expect(
        () => joinFlatUseCase(
          inviteCode: 'FAIR8', // 5 characters
          userId: userId,
          userEmail: userEmail,
        ),
        throwsA(isA<ServerFailure>().having(
          (f) => f.type,
          'type',
          ServerFailureType.unknown,
        )),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('should propagate repository failure when database call throws Failure', () async {
      // Arrange
      final failure = ServerFailure(ServerFailureType.permissionDenied);
      when(() => mockRepository.joinFlatWithCode(
            inviteCode: inviteCode,
            userId: userId,
            userEmail: userEmail,
          )).thenThrow(failure);

      // Act & Assert
      expect(
        () => joinFlatUseCase(
          inviteCode: inviteCode,
          userId: userId,
          userEmail: userEmail,
        ),
        throwsA(equals(failure)),
      );
      verify(() => mockRepository.joinFlatWithCode(
            inviteCode: inviteCode,
            userId: userId,
            userEmail: userEmail,
          )).called(1);
    });
  });
}
