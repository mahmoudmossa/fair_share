import '../../../domain/entities/user_entity.dart';

abstract class UserRemoteDataSource {
  Future<void> createUser(UserEntity user);
}
