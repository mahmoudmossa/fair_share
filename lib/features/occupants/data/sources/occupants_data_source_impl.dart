import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'package:fair_share/features/occupants/data/models/occupants_response.dart';
import 'package:fair_share/features/occupants/data/sources/ouccpants_data_source.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:fair_share/features/new_flat/data/models/flat_member_dto.dart';
import 'package:fair_share/features/auth/data/models/user_dto.dart';

class OccupantsDataSourceImp implements OuccpantsDataSource {
  final FirebaseFirestore _fireStore;
  OccupantsDataSourceImp(this._fireStore);

  @override
  Future<List<OccupantResponse>> getOccupants(String faltId) async {
    final QuerySnapshot<Map<String, dynamic>> data = await _fireStore
        .collection(FirestoreConstants.occupants)
        .where('flatId', isEqualTo: faltId)
        .get();
    final List<OccupantResponse> occupants = data.docs
        .map((doc) => OccupantResponse.fromJson(doc.data()))
        .toList();
    return occupants;
  }

  @override
  Future<void> updateOccupant(String flatId, Occupant occupant) async {
    final batch = _fireStore.batch();

    final memberRef = _fireStore
        .collection(FirestoreConstants.wgs)
        .doc(flatId)
        .collection(FirestoreConstants.members)
        .doc(occupant.id);

    final memberDto = FlatMemberDto(
      id: occupant.id,
      name: occupant.name,
      userId: occupant.userId,
      invitationCode: occupant.invitationCode,
    );
    batch.set(memberRef, memberDto.toJson(), SetOptions(merge: true));

    if (occupant.userId != null && occupant.userId!.isNotEmpty) {
      final userRef = _fireStore.collection(FirestoreConstants.users).doc(occupant.userId);
      final userSnap = await userRef.get();
      if (userSnap.exists && userSnap.data() != null) {
        final userDto = UserDto.fromJson(userSnap.data()!);
        final updatedUserDto = UserDto(
          id: userDto.id,
          email: userDto.email,
          flatId: userDto.flatId,
        );
        batch.set(userRef, updatedUserDto.toJson(), SetOptions(merge: true));
      }
    }

    await batch.commit();
  }
}
