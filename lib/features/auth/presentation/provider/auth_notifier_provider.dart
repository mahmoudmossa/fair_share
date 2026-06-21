import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core/shared_core.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/sign_in_use_case.dart';
import '../../domain/use_cases/sign_out_use_case.dart';

part 'auth_notifier_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  ActionState<UserEntity?> build() {
    return const ActionInitial();
  }

  Future<void> signIn(String email, String password) async {
    state = const ActionLoading();
    final useCase = ref.read(signInUseCaseProvider);
    final result = await useCase(email, password);
    state = result.fold(
      (error) => ActionError(error),
      (user) => ActionSuccess(user),
    );
  }

  Future<void> signOut() async {
    state = const ActionLoading();
    final useCase = ref.read(signOutUseCaseProvider);
    final result = await useCase();
    state = result.fold(
      (error) => ActionError(error),
      (_) => const ActionSuccess(null),
    );
  }
}
