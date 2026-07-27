import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import 'package:fair_share/features/history/domain/repositories/history_repository.dart';
import 'package:fair_share/features/history/domain/use_cases/watch_expenses_for_month_use_case.dart';
import 'package:fair_share/features/new_flat/domain/entities/recurrence_type.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late MockHistoryRepository mockRepo;
  late WatchExpensesForMonthUseCase useCase;

  setUp(() {
    mockRepo = MockHistoryRepository();
    useCase = WatchExpensesForMonthUseCase(mockRepo);
  });

  group('WatchExpensesForMonthUseCase', () {
    test('delegates to repository with correct flatId and monthId', () async {
      const flatId = 'flat-123';
      const monthId = '2026-07';
      final fakeExpense = ExpenseEntity(
        id: 'exp-1',
        title: 'Internet',
        amount: 40.0,
        payerId: 'user-1',
        payerName: 'Alice',
        date: DateTime(2026, 7, 5),
        isDisputed: false,
        recurrence: RecurrenceType.monthly,
      );

      when(() => mockRepo.watchExpensesForMonth(flatId, monthId))
          .thenAnswer((_) => Stream.value([fakeExpense]));

      final result = await useCase(flatId, monthId).first;

      expect(result, [fakeExpense]);
      verify(() => mockRepo.watchExpensesForMonth(flatId, monthId)).called(1);
    });

    test('returns empty list when month has no expenses', () async {
      const flatId = 'flat-123';
      const monthId = '2025-01';

      when(() => mockRepo.watchExpensesForMonth(flatId, monthId))
          .thenAnswer((_) => Stream.value([]));

      final result = await useCase(flatId, monthId).first;

      expect(result, isEmpty);
    });
  });
}
