// TODO: Define the use case for Occupants feature.
import 'package:dartz/dartz.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';

import '../repositories/occupants_repository.dart';

class GetOccupantUseCase {
  final OccupantsRepository repository;

  GetOccupantUseCase(this.repository);

  Future<Either<Failure, List<Occupant>>> call(String flatId) async {
    return repository.getOccupants(flatId);
  }
}
