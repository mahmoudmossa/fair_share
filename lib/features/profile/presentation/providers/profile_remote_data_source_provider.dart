import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import '../../data/data_sources/remote/profile_remote_data_source.dart';
import '../../data/data_sources/remote/profile_remote_data_source_impl.dart';

part 'profile_remote_data_source_provider.g.dart';

@riverpod
ProfileRemoteDataSource profileRemoteDataSource(Ref ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return ProfileRemoteDataSourceImpl(firestore, firebaseAuth);
}
