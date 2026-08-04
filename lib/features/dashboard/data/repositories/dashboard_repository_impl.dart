import 'package:dartz/dartz.dart';
import '../../domain/entities/expense_entity.dart';
import '../models/expense_model.dart';
import '../../domain/entities/dashboard_state.dart';
import '../../domain/entities/debt_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../data_sources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Stream<DashboardState?> watchDashboardState(String flatId) {
    return _remoteDataSource.watchDashboardState(flatId);
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

