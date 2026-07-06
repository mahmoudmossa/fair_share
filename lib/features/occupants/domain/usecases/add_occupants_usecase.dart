import 'package:dartz/dartz.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:fair_share/features/occupants/domain/repositories/occupants_repository.dart';

class AddOccupantsUsecase {
  final OccupantsRepository repo;
  AddOccupantsUsecase(this.repo);

  Future<Either<Failure, void>> call(String flatId, Occupant occupant) async =>
      repo.addOccupant(flatId, occupant);
}
