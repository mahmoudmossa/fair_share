import 'package:fair_share/features/new_flat/data/models/flat_dto.dart'
    show FlatDto;

abstract class FlatRemoteDataSource {
  Future<void> createFlat(FlatDto FlatDto);
  Future<void> updateFlat(FlatDto FlatDto);
  Future<void> deleteFlat(String flatId);
  Future<List<FlatDto>> getAllFlats();
  Future<FlatDto> getFlat(String flatId);
}
