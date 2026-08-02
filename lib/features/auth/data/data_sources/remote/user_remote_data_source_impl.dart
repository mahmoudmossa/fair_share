import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';
import '../../../domain/entities/user_entity.dart';
import 'user_remote_data_source.dart';

part 'user_remote_data_source_impl.g.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore _firestore;

  UserRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> createUser(UserEntity user) async {
    await _firestore
        .collection(FirestoreConstants.users)
        .doc(user.id)
        .set({
      FirestoreConstants.id: user.id,
      'email': user.email,
    });
  }
}

@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) {
  return UserRemoteDataSourceImpl(ref.watch(firebaseFirestoreProvider));
}
