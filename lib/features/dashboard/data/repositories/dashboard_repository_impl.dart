import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/dashboard_state.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../data_sources/dashboard_remote_data_source.dart';
import '../data_sources/dashboard_remote_data_source_impl.dart';

part 'dashboard_repository_impl.g.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Stream<DashboardState?> watchDashboardState(String flatId) {
    return _remoteDataSource.watchDashboardState(flatId);
  }

  @override
  Future<Either<Exception, String>> createFlat(String name, String userId, String userName) async {
    try {
      final flatId = await _remoteDataSource.createFlat(name, userId, userName);
      return Right(flatId);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, bool>> joinFlat(String invitationCode, String userId, String userName) async {
    try {
      final success = await _remoteDataSource.joinFlat(invitationCode, userId, userName);
      return Right(success);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> addExpense(String flatId, String title, double amount, String payerId, String payerName, String category) async {
    try {
      await _remoteDataSource.addExpense(flatId, title, amount, payerId, payerName, category);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> settleDebt(String flatId, String debtId, String userId, String userName) async {
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
}

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  return DashboardRepositoryImpl(ref.watch(dashboardRemoteDataSourceProvider));
}
