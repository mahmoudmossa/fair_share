import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_repository_provider.dart';
import '../repositories/dashboard_repository.dart';

part 'settle_use_case.g.dart';

@riverpod
SettleUseCase settleUseCase(Ref ref) {
  return SettleUseCase(ref.watch(dashboardRepositoryProvider));
}

class SettleUseCase {
  final DashboardRepository repository;

  SettleUseCase(this.repository);

  Future<Either<Exception, void>> call({
    required String flatId,
    required String debtId,
    required String userId,
    required String userName,
  }) {
    return repository.settleDebt(flatId, debtId, userId, userName);
  }
}
