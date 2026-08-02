import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/use_cases/add_new_expense_use_case.dart';
import 'dashboard_repository_provider.dart';

part 'add_new_expense_use_case_provider.g.dart';

@riverpod
AddNewExpenseUseCase addNewExpenseUseCase(Ref ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return AddNewExpenseUseCase(repository);
}
