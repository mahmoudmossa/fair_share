import 'package:dartz/dartz.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/new_flat/data/models/flat_dto.dart';
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
      final flatDto = FlatDto(id: flatEntity.id, name: flatEntity.name);
      await remoteDataSource.createFlat(flatDto);
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
    // TODO: implement deleteFlat
    throw UnimplementedError();
  }

  @override
  Future<List<FlatEntity>> getAllFlats() {
    // TODO: implement getAllFlats
    throw UnimplementedError();
  }

  @override
  Future<FlatEntity> getFlat(String flatId) {
    // TODO: implement getFlat
    throw UnimplementedError();
  }

  @override
  Future<void> updateFlat(FlatEntity flatEntity) {
    // TODO: implement updateFlat
    throw UnimplementedError();
  }

  @override
  Future<Either<Exception, Unit>> callApi() async {
    try {
      return Right(await remoteDataSource.callApi());
    } on Exception catch (exception) {
      return Left(exception);
    }
  }
}
