import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_remote_data_source.dart';
import '../data_sources/remote/user_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final UserRemoteDataSource _userRemoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._userRemoteDataSource);

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((user) {
      if (user == null) return null;
      return UserEntity(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
      );
    });
  }

  @override
  Future<Either<Exception, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _remoteDataSource.signInWithEmail(
        email,
        password,
      );
      final user = credential.user!;
      return Right(
        UserEntity(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
        ),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, UserEntity>> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _remoteDataSource.signUpWithEmail(
        email,
        password,
      );
      final user = credential.user!;
      final userEntity = UserEntity(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
      );
      await _userRemoteDataSource.createUser(userEntity);
      return Right(userEntity);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
