import 'package:fair_share/core/modles/action_state.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:fair_share/features/occupants/domain/usecases/edit_member_usecase.dart';
import 'package:fair_share/features/occupants/presentation/providers/occupants_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_member_provider.g.dart';

@riverpod
class EditMemberNotifier extends _$EditMemberNotifier {
  @override
  ActionState build() {
    return const ActionState.initial();
  }

  Future<void> editMember(Occupant occupant) async {
    state = const ActionState.loading();
    final repository = ref.read(occupantsRepositoryProvider);
    final useCase = EditMemberUseCase(repository);
    final result = await useCase.call(occupant);
    if (!ref.mounted) return;
    state = result.fold(
      (failure) => ActionState.failure(failure),
      (_) => const ActionState.success(),
    );
  }
}
