import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import '../../data/data_sources/remote/join_flat_remote_data_source.dart';
import '../../data/data_sources/remote/join_flat_remote_data_source_impl.dart';

part 'join_flat_remote_data_source_provider.g.dart';

@riverpod
JoinFlatRemoteDataSource joinFlatRemoteDataSource(Ref ref) {
  return JoinFlatRemoteDataSourceImpl(ref.watch(firebaseFirestoreProvider));
}
