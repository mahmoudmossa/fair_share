import 'package:fair_share/features/dashboard/domain/entities/billing_cycle_entity.dart';
import 'package:fair_share/features/dashboard/domain/repositories/dashboard_repository.dart';

class WatchActiveBillingCycleUseCase {
  final DashboardRepository _repository;

  WatchActiveBillingCycleUseCase(this._repository);

  Stream<BillingCycleEntity?> call(String flatId) {
    return _repository.watchActiveBillingCycle(flatId);
  }
}
