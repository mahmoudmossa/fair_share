import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/features/profile/domain/repositories/profile_repository.dart';
import 'package:fair_share/features/profile/domain/use_cases/update_profile_photo_use_case.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;
  late UpdateProfilePhotoUseCase useCase;

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = UpdateProfilePhotoUseCase(mockRepository);
  });

  group('UpdateProfilePhotoUseCase', () {
    const userId = 'user_123';
    const flatId = 'flat_abc';
    const base64Photo = 'dGVzdGJhc2U2NA=='; // valid base64

    test('should call updateProfilePhoto on repository and complete successfully',
        () async {
      when(
        () => mockRepository.updateProfilePhoto(
          userId: userId,
          flatId: flatId,
          base64Photo: base64Photo,
        ),
      ).thenAnswer((_) async {});

      await useCase(
        userId: userId,
        flatId: flatId,
        base64Photo: base64Photo,
      );

      verify(
        () => mockRepository.updateProfilePhoto(
          userId: userId,
          flatId: flatId,
          base64Photo: base64Photo,
        ),
      ).called(1);
    });

    test('should throw exception when repository call fails', () async {
      final exception = Exception('Firestore error');
      when(
        () => mockRepository.updateProfilePhoto(
          userId: userId,
          flatId: flatId,
          base64Photo: base64Photo,
        ),
      ).thenThrow(exception);

      expect(
        () => useCase(
          userId: userId,
          flatId: flatId,
          base64Photo: base64Photo,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('should call updateProfilePhoto without flatId when user has no flat',
        () async {
      when(
        () => mockRepository.updateProfilePhoto(
          userId: userId,
          flatId: null,
          base64Photo: base64Photo,
        ),
      ).thenAnswer((_) async {});

      await useCase(userId: userId, base64Photo: base64Photo);

      verify(
        () => mockRepository.updateProfilePhoto(
          userId: userId,
          flatId: null,
          base64Photo: base64Photo,
        ),
      ).called(1);
    });
  });
}
