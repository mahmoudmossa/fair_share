import 'package:fair_share/features/new_flat/data/models/flat_dto.dart'
    show FlatDto;

abstract class FlatRemoteDataSource {
  Future<void> createFlat(FlatDto flat);
  Future<void> updateFlat(FlatDto flat);
  Future<void> deleteFlat(String flatId);
  Future<List<FlatDto>> getAllFlats();
  Future<FlatDto> getFlat(String flatId);
}
