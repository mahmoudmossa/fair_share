import 'dart:async';
import 'package:dartz/dartz.dart';
import '../entities/dashboard_state.dart';

abstract class DashboardRepository {
  Stream<DashboardState?> watchDashboardState(String flatId);
  Future<Either<Exception, void>> addExpense(
    String flatId,
    String title,
    double amount,
    String payerId,
    String payerName,
    String category,
  );
  Future<Either<Exception, void>> settleDebt(
    String flatId,
    String debtId,
    String userId,
    String userName,
  );
  Future<Either<Exception, String?>> getUserFlatId(String userId);
}
