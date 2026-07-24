import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/modles/action_state.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:fair_share/features/new_flat/domain/use_cases/calculate_settlements.dart';
import 'package:fair_share/features/dashboard/domain/use_cases/set_flat_debts.dart';
import '../../domain/use_cases/create_flat.dart';
import '../../domain/entities/flat_entity.dart';
import '../../domain/entities/flat_member_entity.dart';

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

    await result.fold(
      (failure) async => state = ActionState.failure(failure),
      (_) async {
        try {
          final allMembers = [
            FlatMemberEntity(id: flat.createdBy, name: flat.createdByName),
            ...flat.members,
          ];
          final calculatedDebts = SettlementCalculator.calculateDebts(
            members: allMembers,
            costs: flat.costs,
          );
          final setDebtsUseCase = ref.read(setFlatDebtsUseCaseProvider);
          await setDebtsUseCase(flatId: flat.id, debts: calculatedDebts);
          state = const ActionState.success();
        } catch (e) {
          state = ActionState.failure(ServerFailure(ServerFailureType.unknown));
        }
      },
    );
  }
}
