import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:fair_share/features/occupants/domain/repositories/occupants_repository.dart';
import 'package:fair_share/features/occupants/domain/usecases/edit_member_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOccupantsRepository extends Mock implements OccupantsRepository {}

void main() {
  late EditMemberUseCase useCase;
  late MockOccupantsRepository mockOccupantsRepository;

  setUp(() {
    mockOccupantsRepository = MockOccupantsRepository();
    useCase = EditMemberUseCase(mockOccupantsRepository);
  });

  final tOccupant = Occupant(
    id: 'member_123',
    name: 'Updated Name',
    flatId: 'flat_abc_123',
  );

  test('should call updateOccupant on repository when successful', () async {
    when(
      () => mockOccupantsRepository.updateOccupant(tOccupant),
    ).thenAnswer((_) async => Future.value());

    await useCase(tOccupant);

    verify(() => mockOccupantsRepository.updateOccupant(tOccupant)).called(1);
  });
}
