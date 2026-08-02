import 'package:fair_share/features/join_flat/data/models/invitation_dto.dart';

abstract class JoinFlatRemoteDataSource {
  /// Searches for the invitation document matching the inviteCode.
  /// Throws a FirebaseException if not found.
  Future<InvitationDto> findInvitationByCode(String inviteCode);

  /// Executes the atomic database transaction/batch to join the flat.
  Future<void> executeJoinFlatTransaction({
    required String inviteCode,
    required String flatId,
    required String memberId,
    required String userId,
    required String userEmail,
    required String userName,
  });
}
