import 'package:fair_share/features/dashboard/domain/entities/debt_entity.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
import '../models/expense_model.dart';
import '../models/flat_model.dart';
import '../models/billing_cycle_model.dart';
import '../models/activity_model.dart';

abstract class DashboardRemoteDataSource {
  Stream<FlatModel?> watchFlat(String flatId);
  Stream<List<FlatMemberEntity>> watchFlatMembers(String flatId);
  Stream<BillingCycleModel?> watchActiveBillingCycle(String flatId);
  Stream<List<ExpenseModel>> watchExpenses(String flatId);
  Stream<List<ActivityModel>> watchActivities(String flatId);

  Future<void> addExpense(
    String flatId,
    ExpenseModel expense,
  );
  Future<void> deleteExpense(
    String flatId,
    String expenseId,
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


