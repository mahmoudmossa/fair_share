// TODO: Implement the repository for Occupants feature.
import 'package:dartz/dartz.dart';

import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:fair_share/features/occupants/data/models/occupants_response.dart';
import 'package:fair_share/features/occupants/data/sources/ouccpants_data_source.dart';

import 'package:fair_share/features/occupants/domain/entities/occupant.dart';

import '../../domain/repositories/occupants_repository.dart';

class OccupantsRepositoryImpl implements OccupantsRepository {
  final OuccpantsDataSource _dataSource;
  OccupantsRepositoryImpl(this._dataSource);
  @override
  Future<Either<Failure, void>> addOccupant(String flatId, Occupant occupant) {
    // TODO: implement addOccupant
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Occupant>>> getOccupants(String flatId) async {
    try {
      final List<OccupantResponse> occupants = await _dataSource.getOccupants(
        flatId,
      );
      final result = occupants.map((occupant) => occupant.toEntity()).toList();
      return right(result);
    } catch (e) {
      return left(ServerFailure(ServerFailureType.unknown));
    }
  }

  @override
  Future<Either<Failure, void>> updateOccupant(Occupant occupant) {
    // TODO: implement updateOccupant
    throw UnimplementedError();
  }
}
