import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<Either<Exception, UserEntity>> signInWithEmailAndPassword(String email, String password);
  Future<Either<Exception, UserEntity>> signUpWithEmailAndPassword(String email, String password);
  Future<Either<Exception, Unit>> signOut();
}

