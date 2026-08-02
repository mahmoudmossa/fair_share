import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/features/profile/domain/repositories/profile_repository.dart';
import 'package:fair_share/features/profile/domain/use_cases/update_profile_name_use_case.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockProfileRepository;
  late UpdateProfileNameUseCase useCase;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    useCase = UpdateProfileNameUseCase(mockProfileRepository);
  });

  const userId = 'user123';
  const newName = 'Alex Thompson';

  group('UpdateProfileNameUseCase', () {
    test('should call updateDisplayName on repository and complete successfully', () async {
      when(() => mockProfileRepository.updateDisplayName(
            userId: userId,
            newName: newName,
          )).thenAnswer((_) async {});

      await expectLater(
        useCase(userId: userId, newName: newName),
        completes,
      );

      verify(() => mockProfileRepository.updateDisplayName(
            userId: userId,
            newName: newName,
          )).called(1);
    });

    test('should throw exception when repository call fails', () async {
      final exception = Exception('Failed to update');
      when(() => mockProfileRepository.updateDisplayName(
            userId: userId,
            newName: newName,
          )).thenThrow(exception);

      expect(
        () => useCase(userId: userId, newName: newName),
        throwsA(isA<Exception>()),
      );

      verify(() => mockProfileRepository.updateDisplayName(
            userId: userId,
            newName: newName,
          )).called(1);
    });
  });
}
