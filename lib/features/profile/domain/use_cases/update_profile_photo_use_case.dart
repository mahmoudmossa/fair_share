import '../repositories/profile_repository.dart';

class UpdateProfilePhotoUseCase {
  final ProfileRepository _repository;

  UpdateProfilePhotoUseCase(this._repository);

  Future<void> call({
    required String userId,
    String? flatId,
    required String base64Photo,
  }) {
    return _repository.updateProfilePhoto(
      userId: userId,
      flatId: flatId,
      base64Photo: base64Photo,
    );
  }
}
