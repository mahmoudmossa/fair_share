import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'package:fair_share/core/constants/firestore_constants.dart';

part 'dashboard_provider.g.dart';


@riverpod
Stream<UserEntity?> firestoreUser(Ref ref) {
  final auth = ref.watch(authStateProvider).value;
  if (auth == null) return Stream.value(null);

  final firestore = ref.watch(firebaseFirestoreProvider);
  return firestore
      .collection(FirestoreConstants.users)
      .doc(auth.id)
      .snapshots()
      .map((snap) {
    if (snap.exists && snap.data() != null) {
      final data = snap.data()!;
      return UserEntity(
        id: snap.id,
        email: data['email'] as String? ?? '',
        flatId: data[FirestoreConstants.flatId] as String?,
      );
    }
    return auth;
  });
}


