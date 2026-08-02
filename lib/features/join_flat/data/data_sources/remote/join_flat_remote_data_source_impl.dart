import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'package:fair_share/features/auth/data/models/user_dto.dart';
import 'package:fair_share/features/join_flat/data/models/invitation_dto.dart';
import 'package:fair_share/features/new_flat/data/models/flat_member_dto.dart';
import 'join_flat_remote_data_source.dart';

class JoinFlatRemoteDataSourceImpl implements JoinFlatRemoteDataSource {
  final FirebaseFirestore firestore;

  JoinFlatRemoteDataSourceImpl(this.firestore);

  @override
  Future<InvitationDto> findInvitationByCode(String inviteCode) async {
    final docSnap = await firestore
        .collection('invitations')
        .doc(inviteCode)
        .get();

    if (!docSnap.exists || docSnap.data() == null) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'not-found',
        message: 'No invitation found for code $inviteCode',
      );
    }

    return InvitationDto.fromJson(docSnap.data()!);
  }

  @override
  Future<void> executeJoinFlatTransaction({
    required String inviteCode,
    required String flatId,
    required String memberId,
    required String userId,
    required String userEmail,
    required String userName,
  }) async {
    final batch = firestore.batch();

    // 1. Update user profile to link to the flat and set their displayName
    final userRef = firestore.collection(FirestoreConstants.users).doc(userId);
    final userDto = UserDto(
      id: userId,
      email: userEmail,
      flatId: flatId,
    );
    batch.set(userRef, userDto.toJson(), SetOptions(merge: true));

    // 2. Update member slot inside the WG
    final memberRef = firestore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.members)
        .doc(memberId);
    final memberDto = FlatMemberDto(
      id: memberId,
      name: userName,
      userId: userId,
      invitationCode: inviteCode,
    );
    batch.set(memberRef, memberDto.toJson(), SetOptions(merge: true));

    // 3. Mark the invitation as used
    final inviteRef = firestore.collection('invitations').doc(inviteCode);
    final inviteDto = InvitationDto(
      inviteCode: inviteCode,
      flatId: flatId,
      memberId: memberId,
      memberName: userName,
      status: 'used',
    );
    batch.set(inviteRef, inviteDto.toJson());

    await batch.commit();
  }
}
