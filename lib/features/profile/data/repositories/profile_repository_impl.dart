import '../../domain/repositories/profile_repository.dart';
import '../data_sources/remote/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> updateDisplayName({
    required String userId,
    String? flatId,
    required String newName,
  }) async {
    await _remoteDataSource.updateDisplayName(userId, flatId, newName);
  }
}
