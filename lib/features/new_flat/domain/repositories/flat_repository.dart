import 'package:dartz/dartz.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_entity.dart';

abstract class FlatRepository {
  Future<Either<Failure, void>> createFlat(FlatEntity flatEntity);
  Future<void> updateFlat(FlatEntity flatEntity);
  Future<void> deleteFlat(String flatId);
  Future<List<FlatEntity>> getAllFlats();
  Future<FlatEntity> getFlat(String flatId);
}
