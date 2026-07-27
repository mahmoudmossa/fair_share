import 'package:dartz/dartz.dart';
import '../entities/expense_entity.dart';
import '../repositories/dashboard_repository.dart';

/// [AddNewExpenseUseCase] handles adding a new expense/cost to an existing flat.
///
/// ### Architectural Distinction:
/// - **Initial Flat Setup** (`CreateFlatUseCase` / initial `SettlementCalculator` call):
///   Executes once when creating a new flat to store initial setup details, initial member list,
///   initial seed costs, and to compute the initial baseline debt matrix.
///
/// - **Dynamic Expense Addition** (`AddNewExpenseUseCase`):
///   Executes whenever a flatmate adds a new cost during the active lifetime of the flat.
///   Adding a new expense dynamically requires:
///   1. Appending the new expense record to `wgs/{flatId}/expenses`.
///   2. Logging the user activity event to `wgs/{flatId}/activities`.
///   3. Incrementing `totalCosts` in the active billing cycle `wgs/{flatId}/billingCycles/{monthId}`.
///   4. Fetching all updated flat members and all existing expenses for the flat.
///   5. Recalculating net balances across all flatmates via `SettlementCalculator.calculateDebts`.
///   6. Updating/overwriting the debt matrix in `wgs/{flatId}/debts` and resetting `isSettled` to `false`
///      for all members/debts (since a new cost alters member balances and requires re-settlement).
///   7. Recalculating and updating `settledPercentage` for the active billing cycle.
class AddNewExpenseUseCase {
  final DashboardRepository repository;

  AddNewExpenseUseCase(this.repository);

  Future<Either<Exception, void>> call({
    required String flatId,
    required ExpenseEntity expense,
  }) {
    return repository.addExpense(flatId, expense);
  }
}
