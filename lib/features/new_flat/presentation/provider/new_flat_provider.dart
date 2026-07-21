import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/modles/action_state.dart';
import '../../domain/use_cases/create_flat.dart';
import '../../domain/entities/flat_entity.dart';

part 'new_flat_provider.g.dart';

@riverpod
class NewFlat extends _$NewFlat {
  @override
  ActionState build() {
    return const ActionState.initial();
  }

  Future<void> submitNewFlat(FlatEntity flat) async {
    state = const ActionState.loading();

    final useCase = ref.read(createFlatUseCaseProvider);
    final result = await useCase(flat);

    result.fold(
      (failure) => state = ActionState.failure(failure),
      (_) => state = const ActionState.success(),
    );
  }
}
