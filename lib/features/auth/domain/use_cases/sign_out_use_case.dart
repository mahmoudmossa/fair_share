import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_repository.dart';
import '../../presentation/provider/auth_repository_provider.dart';

part 'sign_out_use_case.g.dart';

class SignOutUseCase {
  final AuthRepository _repository;
  SignOutUseCase(this._repository);

  Future<Either<Exception, Unit>> call() {
    return _repository.signOut();
  }
}

@riverpod
SignOutUseCase signOutUseCase(Ref ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
}
