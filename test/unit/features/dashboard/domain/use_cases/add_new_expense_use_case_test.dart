import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fair_share/features/dashboard/domain/use_cases/add_new_expense_use_case.dart';
import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import 'package:fair_share/features/new_flat/domain/entities/recurrence_type.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late AddNewExpenseUseCase addNewExpenseUseCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    addNewExpenseUseCase = AddNewExpenseUseCase(mockRepository);
  });

  const flatId = 'test-flat-id';
  final testExpense = ExpenseEntity(
    id: 'expense-1',
    title: 'Groceries',
    amount: 45.0,
    payerId: 'user-1',
    payerName: 'Mahmoud',
    date: DateTime(2026, 7, 27),
    isDisputed: false,
    recurrence: RecurrenceType.oneTime,
  );

  group('AddNewExpenseUseCase Unit Tests', () {
    test('should call addExpense on repository and return Right(null) when successful', () async {
      // Arrange
      when(() => mockRepository.addExpense(flatId, testExpense))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await addNewExpenseUseCase(
        flatId: flatId,
        expense: testExpense,
      );

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.addExpense(flatId, testExpense)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate repository failure when addExpense fails', () async {
      // Arrange
      final exception = Exception('Failed to add expense');
      when(() => mockRepository.addExpense(flatId, testExpense))
          .thenAnswer((_) async => Left(exception));

      // Act
      final result = await addNewExpenseUseCase(
        flatId: flatId,
        expense: testExpense,
      );

      // Assert
      expect(result, Left(exception));
      verify(() => mockRepository.addExpense(flatId, testExpense)).called(1);
    });
  });
}
