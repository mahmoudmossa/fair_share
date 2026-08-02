abstract class ProfileRepository {
  Future<void> updateDisplayName({
    required String userId,
    required String newName,
  });
}
