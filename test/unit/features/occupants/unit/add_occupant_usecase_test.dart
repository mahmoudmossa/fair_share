import 'package:dartz/dartz.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:fair_share/features/occupants/domain/repositories/occupants_repository.dart';
import 'package:fair_share/features/occupants/domain/usecases/add_occupants_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOccupantsRepository extends Mock implements OccupantsRepository {}

void main() {
  late MockOccupantsRepository mockRepo;
  late AddOccupantsUsecase usecase;

  setUp(() {
    mockRepo = MockOccupantsRepository();
    usecase = AddOccupantsUsecase(mockRepo);
  });

  group('add occupant', () {
    const String flatId = 'flat_id_123';
    final Occupant occu = Occupant(id: '1', name: 'John Doe');
    test('test succsseffully added occupant', () async {
      // ARRANGE
      when(
        () => mockRepo.addOccupant(flatId, occu),
      ).thenAnswer((_) async => Right(null));
      // ACT
      final result = await usecase.call(flatId, occu);
      // ASSERT
      expect(result, Right(null));
      verify(() => mockRepo.addOccupant(flatId, occu)).called(1);
    });

    test('failure Failure added occupant', () async {
      final tFailure = ServerFailure(ServerFailureType.unknown);
      when(
        () => mockRepo.addOccupant(flatId, occu),
      ).thenAnswer((_) async => Left(tFailure));
      // ACT
      final result = await usecase.call(flatId, occu);
      // ASSERT
      expect(result, Left(tFailure));
      verify(() => mockRepo.addOccupant(flatId, occu)).called(1);
    });
  });
}
