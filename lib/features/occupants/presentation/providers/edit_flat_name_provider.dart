import 'package:fair_share/core/modles/action_state.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:fair_share/features/new_flat/presentation/provider/new_flat_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_flat_name_provider.g.dart';

@riverpod
class EditFlatNameNotifier extends _$EditFlatNameNotifier {
  @override
  ActionState build() {
    return const ActionState.initial();
  }

  Future<void> editFlatName({
    required String flatId,
    required String newName,
  }) async {
    state = const ActionState.loading();
    final repository = ref.read(newFlatRepositoryProvider);
    try {
      final currentFlat = await repository.getFlat(flatId);
      final updatedFlat = currentFlat.copyWith(name: newName);
      await repository.updateFlat(updatedFlat);
      if (!ref.mounted) return;
      state = const ActionState.success();
    } on Failure catch (e) {
      if (!ref.mounted) return;
      state = ActionState.failure(e);
    } catch (e) {
      if (!ref.mounted) return;
      state = ActionState.failure(ServerFailure(ServerFailureType.unknown));
    }
  }
}
