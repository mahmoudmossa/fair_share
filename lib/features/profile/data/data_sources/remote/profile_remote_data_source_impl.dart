import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ProfileRemoteDataSourceImpl(this._firestore, this._firebaseAuth);

  @override
  Future<void> updateDisplayName(String userId, String? flatId, String newName) async {
    if (flatId != null && flatId.isNotEmpty) {
      await _firestore
          .collection(FirestoreConstants.wgs)
          .doc(flatId)
          .collection(FirestoreConstants.members)
          .doc(userId)
          .update({
        FirestoreConstants.displayName: newName,
      });
    }

    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null && currentUser.uid == userId) {
      await currentUser.updateDisplayName(newName);
    }
  }
}
