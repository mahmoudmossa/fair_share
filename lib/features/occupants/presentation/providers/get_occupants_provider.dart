import 'package:dartz/dartz.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/features/occupants/domain/entities/occupant.dart';
import 'package:fair_share/features/occupants/domain/usecases/get_occupants_usecase.dart';
import 'package:fair_share/features/occupants/presentation/providers/occupants_repository_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_occupants_provider.g.dart';

@riverpod
Future<Either<Failure, List<Occupant>>> getOccupants(
  Ref ref, {
  required String flatId,
}) async {
  final repository = ref.watch(occupantsRepositoryProvider);
  final usecase = GetOccupantUseCase(repository);
  return usecase.call(flatId);
}
