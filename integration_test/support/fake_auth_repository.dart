import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';
import 'package:fair_share/features/auth/domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  final _controller = StreamController<UserEntity?>.broadcast();
  UserEntity? _currentUser;

  FakeAuthRepository() {
    _controller.add(null);
  }

  @override
  Stream<UserEntity?> get authStateChanges => _controller.stream;

  @override
  Future<Either<Exception, UserEntity>> signInWithEmailAndPassword(String email, String password) async {
    _currentUser = UserEntity(id: 'fake_uid_123', email: email, displayName: 'Fake User');
    _controller.add(_currentUser);
    return Right(_currentUser!);
  }

  @override
  Future<Either<Exception, UserEntity>> signUpWithEmailAndPassword(String email, String password) async {
    _currentUser = UserEntity(id: 'fake_uid_123', email: email, displayName: 'Fake User');
    _controller.add(_currentUser);
    return Right(_currentUser!);
  }

  @override
  Future<Either<Exception, Unit>> signOut() async {
    _currentUser = null;
    _controller.add(null);
    return const Right(unit);
  }
}
