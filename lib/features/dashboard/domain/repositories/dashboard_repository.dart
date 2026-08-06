import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
import '../entities/debt_entity.dart';
import '../entities/expense_entity.dart';
import '../entities/billing_cycle_entity.dart';
import '../entities/activity_entity.dart';
import '../entities/flat_entity.dart';


abstract class DashboardRepository {
  Stream<FlatEntity?> watchFlat(String flatId);
  Stream<List<FlatMemberEntity>> watchFlatMembers(String flatId);
  Stream<BillingCycleEntity?> watchActiveBillingCycle(String flatId);
  Stream<List<ExpenseEntity>> watchExpenses(String flatId);
  Stream<List<ActivityEntity>> watchActivities(String flatId);

  Future<Either<Exception, void>> addExpense(

    String flatId,
    ExpenseEntity expense,
  );
  Future<Either<Exception, void>> deleteExpense(
    String flatId,
    String expenseId,
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

