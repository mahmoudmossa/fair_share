import 'package:fair_share/features/dashboard/domain/entities/dashboard_state.dart';

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
}
