import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_repository_provider.dart';
import '../repositories/dashboard_repository.dart';
import '../entities/debt_entity.dart';

part 'set_flat_debts.g.dart';

@riverpod
SetFlatDebtsUseCase setFlatDebtsUseCase(Ref ref) {
  return SetFlatDebtsUseCase(ref.watch(dashboardRepositoryProvider));
}

class SetFlatDebtsUseCase {
  final DashboardRepository repository;

  SetFlatDebtsUseCase(this.repository);

  Future<void> call({required String flatId, required List<DebtEntity> debts}) async {
    await repository.setFlatDebts(flatId, debts);
  }
}
