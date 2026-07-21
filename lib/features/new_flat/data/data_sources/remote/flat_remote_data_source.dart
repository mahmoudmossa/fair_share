import 'package:fair_share/features/new_flat/data/models/flat_dto.dart';
import 'package:fair_share/features/new_flat/data/models/flat_member_dto.dart';
import 'package:fair_share/features/new_flat/data/models/flat_cost_dto.dart';

abstract class FlatRemoteDataSource {
  Future<void> createFlat({
    required FlatDto flat,
    required List<FlatMemberDto> members,
    required List<FlatCostDto> costs,
  });
  Future<void> updateFlat(FlatDto flat);
  Future<void> deleteFlat(String flatId);
  Future<List<FlatDto>> getAllFlats();
  Future<FlatDto> getFlat(String flatId);
}
