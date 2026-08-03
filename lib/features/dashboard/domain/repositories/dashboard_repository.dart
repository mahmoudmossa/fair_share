import 'dart:async';
import 'package:dartz/dartz.dart';
import '../entities/dashboard_state.dart';
import '../entities/debt_entity.dart';
import '../entities/expense_entity.dart';

abstract class DashboardRepository {
  Stream<DashboardState?> watchDashboardState(String flatId);
  Future<Either<Exception, void>> addExpense(
    String flatId,
    ExpenseEntity expense,
  );
  Future<Either<Exception, void>> settleDebt(
    String flatId,
    String debtId,
    String userId,
    String userName,
  );
  Future<Either<Exception, String?>> getUserFlatId(String userId);
  Future<void> setFlatDebts(String flatId, List<DebtEntity> debts);
  Stream<List<DebtEntity>> watchFlatDebts(String flatId);
  Future<void> updateBillingCalculationDay(String flatId, int day);
  Future<void> calculateMonthlyExpensesAndNotify(String flatId);
}

