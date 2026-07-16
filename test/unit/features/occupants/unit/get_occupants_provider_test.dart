import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:fair_share/features/occupants/domain/repositories/occupants_repository.dart';
import 'package:fair_share/features/occupants/domain/usecases/get_occupants_usecase.dart';
import 'package:fair_share/features/occupants/presentation/providers/get_occupants_provider.dart';
import 'package:fair_share/features/occupants/presentation/providers/occupants_repository_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrol/patrol.dart';

import 'package:fair_share/core/errors/failures.dart' as failure;

class MockOccupantsRepository extends Mock implements OccupantsRepository {}

void main() {
  late MockOccupantsRepository repo;
  late GetOccupantUseCase useCase;

  setUp(() {
    repo = MockOccupantsRepository();
    useCase = GetOccupantUseCase(repo);
  });

  ProviderContainer makeContainer(MockOccupantsRepository mockRepo) {
    final container = ProviderContainer(
      overrides: [occupantsRepositoryProvider.overrideWith((ref) => mockRepo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('getOccupantsProvider', () {
    const tFlatId = 'flat_abc_123';
    final tOccupants = [
      Occupant(id: '1', name: 'Alice'),
      Occupant(id: '2', name: 'Bob'),
    ];
    test('success get occupants', () async {
      // Arrange
      when(
        () => repo.getOccupants(tFlatId),
      ).thenAnswer((_) async => Right(tOccupants));

      // Act
      final container = makeContainer(repo);
      final result = await container.read(
        getOccupantsProvider(flatId: tFlatId).future,
      );

      // Assert
      expect(result, Right(tOccupants));

      // verifiy provider that call only one with the parmeter
      verify(() => repo.getOccupants(tFlatId)).called(1);
      verifyNoMoreInteractions(repo);
    });

    test('failure get occupants', () async {
      final tFailure = failure.ServerFailure(ServerFailureType.unknown);
      // Arrange
      when((() => repo.getOccupants(tFlatId))).thenAnswer((_) async {
        return Left(tFailure);
      });

      // ACT
      final container = makeContainer(repo);
      final result = await container.read(
        getOccupantsProvider(flatId: tFlatId).future,
      );
      // Assert
      expect(result, Left(tFailure));
      verify(() => repo.getOccupants(tFlatId)).called(1);
      verifyNoMoreInteractions(repo);
    });
  });
}
