import 'package:dartz/dartz.dart';
import 'package:fair_share/features/occupants/data/models/occupants_response.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';

abstract class OuccpantsDataSource {
  Future<List<OccupantResponse>> getOccupants(String faltId);
}
