import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/debt_entity.dart';
import '../../domain/use_cases/get_flat_debts.dart';

part 'flat_debts_provider.g.dart';

@riverpod
Stream<List<DebtEntity>> flatDebts(Ref ref, String flatId) {
  final useCase = ref.watch(getFlatDebtsUseCaseProvider);
  return useCase(flatId);
}
