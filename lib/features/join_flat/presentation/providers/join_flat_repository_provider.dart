import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/app_error_handler_provider.dart';
import 'package:fair_share/core/providers/firebase_error_mapper_provider.dart';
import '../../data/repositories/join_flat_repository_impl.dart';
import '../../domain/repositories/join_flat_repository.dart';
import 'join_flat_remote_data_source_provider.dart';

part 'join_flat_repository_provider.g.dart';

@riverpod
JoinFlatRepository joinFlatRepository(Ref ref) {
  return JoinFlatRepositoryImpl(
    remoteDataSource: ref.watch(joinFlatRemoteDataSourceProvider),
    errorHandler: ref.watch(appErrorHandlerProvider),
    errorMapper: ref.watch(firebaseErrorMapperProvider),
  );
}
