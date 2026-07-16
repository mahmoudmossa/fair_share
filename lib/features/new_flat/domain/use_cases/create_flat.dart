import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_entity.dart';
import 'package:fair_share/features/new_flat/presentation/provider/new_flat_repository_provider.dart';
import '../repositories/flat_repository.dart';

part 'create_flat.g.dart';

@riverpod
CreateFlatUseCase createFlatUseCase(Ref ref) {
  return CreateFlatUseCase(ref.watch(newFlatRepositoryProvider));
}

class CreateFlatUseCase {
  final FlatRepository repository;

  CreateFlatUseCase(this.repository);

  Future<Either<Failure, void>> call(FlatEntity flatEntity) async {
    return await repository.createFlat(flatEntity);
  }
}
