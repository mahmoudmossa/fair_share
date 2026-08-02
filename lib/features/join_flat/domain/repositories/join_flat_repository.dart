abstract class JoinFlatRepository {
  /// Attempts to join a flat using a unique 6-digit invite code.
  /// Throws a Failure if the code is invalid or a database/network error occurs.
  Future<void> joinFlatWithCode({
    required String inviteCode,
    required String userId,
    required String userEmail,
  });
}
