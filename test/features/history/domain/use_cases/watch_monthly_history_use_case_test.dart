import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/features/history/domain/entities/month_summary_entity.dart';
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
    test('delegates to repository.watchMonthlyHistory with correct flatId',
        () async {
      const flatId = 'flat-123';
      final fakeEntity = MonthSummaryEntity(
        monthId: '2026-07',
        monthLabel: 'Jul 2026',
        total: 1200.0,
        myShare: 300.0,
        lockedAt: DateTime(2026, 7, 20),
      );

      when(() => mockRepo.watchMonthlyHistory(flatId))
          .thenAnswer((_) => Stream.value([fakeEntity]));

      final result = await useCase(flatId).first;

      expect(result, [fakeEntity]);
      verify(() => mockRepo.watchMonthlyHistory(flatId)).called(1);
    });

    test('propagates errors from the repository stream', () {
      const flatId = 'flat-abc';
      when(() => mockRepo.watchMonthlyHistory(flatId))
          .thenAnswer((_) => Stream.error(Exception('Firestore error')));

      expect(useCase(flatId), emitsError(isA<Exception>()));
    });
  });
}
