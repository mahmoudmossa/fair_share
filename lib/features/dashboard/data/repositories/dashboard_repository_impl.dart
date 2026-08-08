import 'package:dartz/dartz.dart';
import '../models/expense_model.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/entities/billing_cycle_entity.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/flat_entity.dart';
import '../../domain/entities/debt_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../data_sources/dashboard_remote_data_source.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';


class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Stream<FlatEntity?> watchFlat(String flatId) {
    return _remoteDataSource.watchFlat(flatId).map((m) => m?.toEntity());
  }

  @override
  Stream<List<FlatMemberEntity>> watchFlatMembers(String flatId) {
    return _remoteDataSource.watchFlatMembers(flatId);
  }


  @override
  Stream<BillingCycleEntity?> watchActiveBillingCycle(String flatId) {
    return _remoteDataSource
        .watchActiveBillingCycle(flatId)
        .map((m) => m?.toEntity());
  }

  @override
  Stream<List<ExpenseEntity>> watchExpenses(String flatId) {
    return _remoteDataSource
        .watchExpenses(flatId)
        .map((list) => list.map((m) => m.toEntity()).toList());
  }

  @override
  Stream<List<ActivityEntity>> watchActivities(String flatId) {
    return _remoteDataSource
        .watchActivities(flatId)
        .map((list) => list.map((m) => m.toEntity()).toList());
  }


  @override
  Future<Either<Exception, void>> addExpense(
    String flatId,
    ExpenseEntity expense,
  ) async {
    try {
      await _remoteDataSource.addExpense(
        flatId,
        ExpenseModel.fromEntity(expense),
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> deleteExpense(
    String flatId,
    String expenseId,
  ) async {
    try {
      await _remoteDataSource.deleteExpense(flatId, expenseId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> settleDebt(
    String flatId,
    String debtId,
    String userId,
    String userName,
  ) async {
    try {
      await _remoteDataSource.settleDebt(flatId, debtId, userId, userName);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, String?>> getUserFlatId(String userId) async {
    try {
      final flatId = await _remoteDataSource.getUserFlatId(userId);
      return Right(flatId);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<void> setFlatDebts(String flatId, List<DebtEntity> debts) async {
    await _remoteDataSource.setFlatDebts(flatId, debts);
  }

  @override
  Stream<List<DebtEntity>> watchFlatDebts(String flatId) {
    return _remoteDataSource.watchFlatDebts(flatId);
  }

  @override
  Future<void> updateBillingCalculationDay(String flatId, int day) async {
    await _remoteDataSource.updateBillingCalculationDay(flatId, day);
  }

  @override
  Future<void> calculateMonthlyExpensesAndNotify(String flatId) async {
    await _remoteDataSource.calculateMonthlyExpensesAndNotify(flatId);
  }
}

