import 'package:dartz/dartz.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:fair_share/core/providers/firebase_error_mapper_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/new_flat/data/models/flat_dto.dart';
import 'package:fair_share/features/new_flat/data/models/flat_member_dto.dart';
import 'package:fair_share/features/new_flat/data/models/flat_cost_dto.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_entity.dart';
import 'package:fair_share/features/new_flat/data/data_sources/remote/flat_remote_data_source.dart';
import 'package:fair_share/features/new_flat/domain/repositories/flat_repository.dart';

class FlatRepositoryImpl implements FlatRepository {
  final FlatRemoteDataSource remoteDataSource;
  final AppErrorHandler errorHandler;
  final FirebaseErrorMapper firebaseErrorMapper;

  FlatRepositoryImpl({
    required this.remoteDataSource,
    required this.errorHandler,
    required this.firebaseErrorMapper,
  });

  @override
  Future<Either<Failure, void>> createFlat(FlatEntity flatEntity) async {
    try {
      final flatDto = FlatDto.fromEntity(flatEntity);
      final membersDto = flatEntity.members
          .map((m) => FlatMemberDto.fromEntity(m))
          .toList();
      final costsDto = flatEntity.costs
          .map((c) => FlatCostDto.fromEntity(c))
          .toList();

      await remoteDataSource.createFlat(
        flat: flatDto,
        members: membersDto,
        costs: costsDto,
      );
      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      errorHandler.handle(
        e,
        stackTrace,
        context: 'FlatRepositoryImpl.createFlat',
      );

      return Left(firebaseErrorMapper.mapException(e));
    } catch (e, stackTrace) {
      errorHandler.handle(
        e,
        stackTrace,
        context: 'FlatRepositoryImpl.createFlat',
      );
      return Left(ServerFailure(ServerFailureType.unknown));
    }
  }

  @override
  Future<void> deleteFlat(String flatId) {
    throw UnimplementedError();
  }

  @override
  Future<List<FlatEntity>> getAllFlats() {
    throw UnimplementedError();
  }

  @override
  Future<FlatEntity> getFlat(String flatId) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateFlat(FlatEntity flatEntity) {
    throw UnimplementedError();
  }
}
