import 'package:fair_share/core/providers/firebase_error_mapper_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/app_error_handler_provider.dart';
import 'package:fair_share/features/new_flat/domain/repositories/flat_repository.dart';
import 'package:fair_share/features/new_flat/data/repositories/new_flat_repository_impl.dart';
import 'package:fair_share/features/new_flat/data/data_sources/remote/flat_remote_data_source_impl.dart';

part 'new_flat_repository_provider.g.dart';

@riverpod
FlatRepository newFlatRepository(Ref ref) {
  return FlatRepositoryImpl(
    remoteDataSource: ref.watch(flatRemoteDataSourceProvider),
    errorHandler: ref.watch(appErrorHandlerProvider),
    firebaseErrorMapper: ref.watch(firebaseErrorMapperProvider),
  );
}
