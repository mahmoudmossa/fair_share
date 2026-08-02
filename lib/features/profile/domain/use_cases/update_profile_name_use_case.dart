import '../repositories/profile_repository.dart';

class UpdateProfileNameUseCase {
  final ProfileRepository _repository;

  UpdateProfileNameUseCase(this._repository);

  Future<void> call({
    required String userId,
    required String newName,
  }) {
    return _repository.updateDisplayName(userId: userId, newName: newName);
  }
}
