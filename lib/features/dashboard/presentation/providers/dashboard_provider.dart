import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import '../../domain/entities/dashboard_state.dart';
import 'dashboard_repository_provider.dart';

part 'dashboard_provider.g.dart';

@riverpod
Stream<UserEntity?> firestoreUser(Ref ref) {
  final auth = ref.watch(authStateProvider).value;
  if (auth == null) return Stream.value(null);

  final firestore = ref.watch(firebaseFirestoreProvider);
  return firestore.collection('users').doc(auth.id).snapshots().map((snap) {
    if (snap.exists && snap.data() != null) {
      final data = snap.data()!;
      return UserEntity(
        id: snap.id,
        email: data['email'] as String? ?? '',
        displayName: data['displayName'] as String? ?? '',
        flatId: data['flatId'] as String?,
      );
    }
    return auth;
  });
}

@riverpod
Stream<DashboardState?> dashboardState(Ref ref) {
  final user = ref.watch(firestoreUserProvider).value;
  if (user == null || user.flatId == null || user.flatId!.isEmpty) {
    return Stream.value(null);
  }

  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.watchDashboardState(user.flatId!);
}
