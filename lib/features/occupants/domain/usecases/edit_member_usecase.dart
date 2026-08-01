import 'package:dartz/dartz.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:fair_share/features/occupants/domain/repositories/occupants_repository.dart';

class EditMemberUseCase {
  final OccupantsRepository repository;

  EditMemberUseCase(this.repository);

  Future<Either<Failure, void>> call(Occupant occupant) async {
    return repository.updateOccupant(occupant);
  }
}
