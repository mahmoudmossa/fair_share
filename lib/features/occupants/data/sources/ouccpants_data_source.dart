import 'package:fair_share/features/occupants/data/models/occupants_response.dart';

abstract class OuccpantsDataSource {
  Future<List<OccupantResponse>> getOccupants(String faltId);
  Future<void> updateOccupant(String flatId, Occupant occupant);
}
