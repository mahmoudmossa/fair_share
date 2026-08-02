abstract class ProfileRepository {
  Future<void> updateDisplayName({
    required String userId,
    String? flatId,
    required String newName,
  });

  Future<void> updateProfilePhoto({
    required String userId,
    String? flatId,
    required String base64Photo,
  });
}
