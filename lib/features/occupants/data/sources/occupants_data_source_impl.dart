import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'package:fair_share/features/occupants/data/models/occupants_response.dart';
import 'package:fair_share/features/occupants/data/sources/ouccpants_data_source.dart';
import 'package:firebase_core/firebase_core.dart';

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
}
