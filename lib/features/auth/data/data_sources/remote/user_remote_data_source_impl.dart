import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import '../../../domain/entities/user_entity.dart';
import 'user_remote_data_source.dart';

part 'user_remote_data_source_impl.g.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore _firestore;

  UserRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> createUser(UserEntity user) async {
    await _firestore.collection('users').doc(user.id).set({
      'id': user.id,
      'email': user.email,
      'displayName': user.displayName ?? '',
    });
  }
}

@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) {
  return UserRemoteDataSourceImpl(ref.watch(firebaseFirestoreProvider));
}
