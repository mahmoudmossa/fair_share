abstract class ProfileRemoteDataSource {
  Future<void> updateDisplayName(String userId, String? flatId, String newName);
  Future<void> updateProfilePhoto(String userId, String? flatId, String base64Photo);
}
