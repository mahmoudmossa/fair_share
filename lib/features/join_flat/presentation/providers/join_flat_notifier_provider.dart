import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/modles/action_state.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'join_flat_use_case_provider.dart';

part 'join_flat_notifier_provider.g.dart';

@riverpod
class JoinFlatNotifier extends _$JoinFlatNotifier {
  @override
  ActionState build() {
    return const ActionState.initial();
  }

  Future<void> joinFlat(String inviteCode) async {
    state = const ActionState.loading();

    try {
      final auth = await ref.read(authStateProvider.future);
      if (auth == null) {
        state = ActionState.failure(ServerFailure(ServerFailureType.unauthenticated));
        return;
      }

      final useCase = ref.read(joinFlatUseCaseProvider);
      await useCase(
        inviteCode: inviteCode,
        userId: auth.id,
        userEmail: auth.email,
      );

      state = const ActionState.success();
    } on Failure catch (failure) {
      state = ActionState.failure(failure);
    } catch (e) {
      state = ActionState.failure(ServerFailure(ServerFailureType.unknown));
    }
  }
}
