abstract class ProfileRemoteDataSource {
  Future<void> updateDisplayName(String userId, String? flatId, String newName);
}
