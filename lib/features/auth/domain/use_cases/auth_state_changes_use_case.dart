import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

part 'auth_state_changes_use_case.g.dart';

class AuthStateChangesUseCase {
  final AuthRepository _repository;
  AuthStateChangesUseCase(this._repository);

  Stream<UserEntity?> call() => _repository.authStateChanges;
}

@riverpod
AuthStateChangesUseCase authStateChangesUseCase(Ref ref) {
  return AuthStateChangesUseCase(ref.watch(authRepositoryProvider));
}
