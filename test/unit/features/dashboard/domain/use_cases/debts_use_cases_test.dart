import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fair_share/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fair_share/features/dashboard/domain/entities/debt_entity.dart';
import 'package:fair_share/features/dashboard/domain/use_cases/set_flat_debts.dart';
import 'package:fair_share/features/dashboard/domain/use_cases/get_flat_debts.dart';
import 'package:fair_share/features/dashboard/domain/use_cases/settle_use_case.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late SetFlatDebtsUseCase setFlatDebtsUseCase;
  late GetFlatDebtsUseCase getFlatDebtsUseCase;
  late SettleUseCase settleUseCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    setFlatDebtsUseCase = SetFlatDebtsUseCase(mockRepository);
    getFlatDebtsUseCase = GetFlatDebtsUseCase(mockRepository);
    settleUseCase = SettleUseCase(mockRepository);
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

  group('SettleUseCase Unit Tests', () {
    test('should call settleDebt on repository and return Right(null) when successful', () async {
      // Arrange
      when(() => mockRepository.settleDebt(flatId, 'debt-1', 'user-1', 'User One'))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await settleUseCase(
        flatId: flatId,
        debtId: 'debt-1',
        userId: 'user-1',
        userName: 'User One',
      );

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.settleDebt(flatId, 'debt-1', 'user-1', 'User One')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate repository errors on settleDebt failure', () async {
      // Arrange
      final exception = Exception('Settle error');
      when(() => mockRepository.settleDebt(flatId, 'debt-1', 'user-1', 'User One'))
          .thenAnswer((_) async => Left(exception));

      // Act
      final result = await settleUseCase(
        flatId: flatId,
        debtId: 'debt-1',
        userId: 'user-1',
        userName: 'User One',
      );

      // Assert
      expect(result, Left(exception));
      verify(() => mockRepository.settleDebt(flatId, 'debt-1', 'user-1', 'User One')).called(1);
    });
  });
}
