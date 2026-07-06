// TODO: Define the repository interface for Occupants feature.
import 'package:dartz/dartz.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';

abstract class OccupantsRepository {
  Future<Either<Failure, void>> addOccupant(String flatId, Occupant occupant);
  Future<Either<Failure, void>> updateOccupant(Occupant occupant);
  Future<Either<Failure, List<Occupant>>> getOccupants(String flatId);
}
