import 'package:fair_share/features/dashboard/domain/entities/dashboard_state.dart';
import 'package:fair_share/features/dashboard/domain/entities/debt_entity.dart';

abstract class DashboardRemoteDataSource {
  Stream<DashboardState?> watchDashboardState(String flatId);
  Future<void> addExpense(
    String flatId,
    String title,
    double amount,
    String payerId,
    String payerName,
    String category,
  );
  Future<void> settleDebt(
    String flatId,
    String debtId,
    String userId,
    String userName,
  );
  Future<String?> getUserFlatId(String userId);
  Future<void> setFlatDebts(String flatId, List<DebtEntity> debts);
  Stream<List<DebtEntity>> watchFlatDebts(String flatId);
}
