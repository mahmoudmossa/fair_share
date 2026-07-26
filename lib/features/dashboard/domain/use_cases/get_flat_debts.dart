import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_repository_provider.dart';
import '../repositories/dashboard_repository.dart';
import '../entities/debt_entity.dart';

part 'get_flat_debts.g.dart';

@riverpod
GetFlatDebtsUseCase getFlatDebtsUseCase(Ref ref) {
  return GetFlatDebtsUseCase(ref.watch(dashboardRepositoryProvider));
}

class GetFlatDebtsUseCase {
  final DashboardRepository repository;

  GetFlatDebtsUseCase(this.repository);

  Stream<List<DebtEntity>> call(String flatId) {
    return repository.watchFlatDebts(flatId);
  }
}
