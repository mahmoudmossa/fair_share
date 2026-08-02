abstract class ProfileRepository {
  Future<void> updateDisplayName({
    required String userId,
    String? flatId,
    required String newName,
  });
}
