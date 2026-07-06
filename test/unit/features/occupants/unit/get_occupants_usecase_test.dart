import 'package:dartz/dartz.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:fair_share/features/occupants/domain/repositories/occupants_repository.dart';
import 'package:fair_share/features/occupants/domain/usecases/get_occupants_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOcuupantsRepository extends Mock implements OccupantsRepository {}

void main() {
  late GetOccupantUseCase useCase;
  late MockOcuupantsRepository mockOcuupantsRepository;

  setUp(() {
    mockOcuupantsRepository = MockOcuupantsRepository();
    useCase = GetOccupantUseCase(mockOcuupantsRepository);
  });
  const tFlatId = 'flat_abc_123';
  final tOccupants = [
    Occupant(id: '1', name: 'Alice'),
    Occupant(id: '2', name: 'Bob'),
  ];
  test('should return list of Occupants', () async {
    when(
      () => mockOcuupantsRepository.getOccupants(tFlatId),
    ).thenAnswer((_) async => Right(tOccupants));
    final result = await useCase(tFlatId);
    expect(result, Right(tOccupants));
    verify(() => mockOcuupantsRepository.getOccupants(tFlatId)).called(1);
  });
}
