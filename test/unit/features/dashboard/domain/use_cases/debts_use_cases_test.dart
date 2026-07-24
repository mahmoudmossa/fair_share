import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fair_share/features/dashboard/domain/entities/debt_entity.dart';
import 'package:fair_share/features/dashboard/domain/use_cases/set_flat_debts.dart';
import 'package:fair_share/features/dashboard/domain/use_cases/get_flat_debts.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late SetFlatDebtsUseCase setFlatDebtsUseCase;
  late GetFlatDebtsUseCase getFlatDebtsUseCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    setFlatDebtsUseCase = SetFlatDebtsUseCase(mockRepository);
    getFlatDebtsUseCase = GetFlatDebtsUseCase(mockRepository);
  });

  const flatId = 'test-flat-id';
  final testDebts = [
    const DebtEntity(
      id: 'debt-1',
      fromId: 'user-1',
      fromName: 'User One',
      toId: 'user-2',
      toName: 'User Two',
      amount: 15.50,
      isSettled: false,
    ),
  ];

  group('SetFlatDebtsUseCase Unit Tests', () {
    test('should call setFlatDebts on repository', () async {
      // Arrange
      when(() => mockRepository.setFlatDebts(flatId, testDebts))
          .thenAnswer((_) async => {});

      // Act
      await setFlatDebtsUseCase(flatId: flatId, debts: testDebts);

      // Assert
      verify(() => mockRepository.setFlatDebts(flatId, testDebts)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate repository errors on setFlatDebts failure', () async {
      // Arrange
      final exception = Exception('Database error');
      when(() => mockRepository.setFlatDebts(flatId, testDebts))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => setFlatDebtsUseCase(flatId: flatId, debts: testDebts),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.setFlatDebts(flatId, testDebts)).called(1);
    });
  });

  group('GetFlatDebtsUseCase Unit Tests', () {
    test('should call watchFlatDebts on repository and return stream of debts', () {
      // Arrange
      when(() => mockRepository.watchFlatDebts(flatId))
          .thenAnswer((_) => Stream.value(testDebts));

      // Act
      final stream = getFlatDebtsUseCase(flatId);

      // Assert
      expect(stream, emits(testDebts));
      verify(() => mockRepository.watchFlatDebts(flatId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
