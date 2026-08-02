import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:fair_share/features/occupants/data/repositories/occupants_repository_impl.dart';
import 'package:fair_share/features/occupants/data/sources/ouccpants_data_source.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOccupantsDataSource extends Mock implements OuccpantsDataSource {}

class FakeOccupant extends Fake implements Occupant {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeOccupant());
  });

  late OccupantsRepositoryImpl repository;
  late MockOccupantsDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockOccupantsDataSource();
    repository = OccupantsRepositoryImpl(mockDataSource);
  });

  group('updateOccupant', () {
    final tOccupant = Occupant(
      id: 'member_123',
      name: 'Updated Name',
      flatId: 'flat_abc_123',
    );

    test('should call updateOccupant on data source successfully', () async {
      when(
        () => mockDataSource.updateOccupant('flat_abc_123', tOccupant),
      ).thenAnswer((_) async {});

      await repository.updateOccupant(tOccupant);

      verify(() => mockDataSource.updateOccupant('flat_abc_123', tOccupant)).called(1);
    });

    test('should throw ServerFailure when flatId is null', () async {
      final invalidOccupant = Occupant(
        id: 'member_123',
        name: 'Updated Name',
        flatId: null,
      );

      expect(
        () => repository.updateOccupant(invalidOccupant),
        throwsA(isA<ServerFailure>().having(
          (f) => f.type,
          'type',
          ServerFailureType.unknown,
        )),
      );
      verifyNever(() => mockDataSource.updateOccupant(any(), any()));
    });

    test('should throw ServerFailure when data source throws Exception', () async {
      when(
        () => mockDataSource.updateOccupant('flat_abc_123', tOccupant),
      ).thenThrow(Exception('database error'));

      expect(
        () => repository.updateOccupant(tOccupant),
        throwsA(isA<ServerFailure>().having(
          (f) => f.type,
          'type',
          ServerFailureType.unknown,
        )),
      );
    });
  });
}
