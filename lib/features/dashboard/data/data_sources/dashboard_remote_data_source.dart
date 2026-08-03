import 'package:fair_share/features/dashboard/domain/entities/dashboard_state.dart';
import 'package:fair_share/features/dashboard/domain/entities/debt_entity.dart';
import '../models/expense_model.dart';

abstract class DashboardRemoteDataSource {
  Stream<DashboardState?> watchDashboardState(String flatId);
  Future<void> addExpense(
    String flatId,
    ExpenseModel expense,
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
  Future<void> updateBillingCalculationDay(String flatId, int day);
  Future<void> calculateMonthlyExpensesAndNotify(String flatId);
}

