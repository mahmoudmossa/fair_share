import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import 'profile_remote_data_source.dart';

/// Max allowed base64 size in bytes (~100 KB) to keep Firestore doc under 1 MB.
const int _maxBase64Bytes = 100 * 1024;

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ProfileRemoteDataSourceImpl(this._firestore, this._firebaseAuth);

  @override
  Future<void> updateDisplayName(
    String userId,
    String? flatId,
    String newName,
  ) async {
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

  @override
  Future<void> updateProfilePhoto(
    String userId,
    String? flatId,
    String base64Photo,
  ) async {
    if (base64Photo.length > _maxBase64Bytes) {
      throw Exception(
        'Image is too large. Please select a smaller image.',
      );
    }

    final batch = _firestore.batch();

    // Update the user's own document
    final userRef = _firestore
        .collection(FirestoreConstants.users)
        .doc(userId);
    batch.update(userRef, {
      FirestoreConstants.photoBase64: base64Photo,
    });

    // Update the member document in the flat (if member of a flat)
    if (flatId != null && flatId.isNotEmpty) {
      final memberRef = _firestore
          .collection(FirestoreConstants.wgs)
          .doc(flatId)
          .collection(FirestoreConstants.members)
          .doc(userId);
      batch.update(memberRef, {
        FirestoreConstants.photoBase64: base64Photo,
      });
    }

    await batch.commit();
  }
}
