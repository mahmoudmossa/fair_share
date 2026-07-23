import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/data_sources/remote/auth_remote_data_source_impl.dart';
import '../../data/data_sources/remote/user_remote_data_source_impl.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(userRemoteDataSourceProvider),
  );
}
