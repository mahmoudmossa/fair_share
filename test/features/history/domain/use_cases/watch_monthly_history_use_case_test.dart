import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/features/dashboard/domain/entities/expense_entity.dart';
import 'package:fair_share/features/history/domain/repositories/history_repository.dart';
import 'package:fair_share/features/history/domain/use_cases/watch_monthly_history_use_case.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late MockHistoryRepository mockRepo;
  late WatchMonthlyHistoryUseCase useCase;

  setUp(() {
    mockRepo = MockHistoryRepository();
    useCase = WatchMonthlyHistoryUseCase(mockRepo);
  });

  group('WatchMonthlyHistoryUseCase', () {
    test('delegates to repository.watchAllExpenses with correct flatId',
        () async {
      const flatId = 'flat-123';
      final fakeExpense = ExpenseEntity(
        id: 'exp-1',
        title: 'Rent',
        amount: 1200.0,
        payerId: 'user-1',
        payerName: 'John',
        date: DateTime(2026, 7, 20),
        isDisputed: false,
      );

      when(() => mockRepo.watchAllExpenses(flatId))
          .thenAnswer((_) => Stream.value([fakeExpense]));

      final result = await useCase(flatId).first;

      expect(result, [fakeExpense]);
      verify(() => mockRepo.watchAllExpenses(flatId)).called(1);
    });

    test('propagates errors from the repository stream', () {
      const flatId = 'flat-abc';
      when(() => mockRepo.watchAllExpenses(flatId))
          .thenAnswer((_) => Stream.error(Exception('Firestore error')));

      expect(useCase(flatId), emitsError(isA<Exception>()));
    });
  });
}
