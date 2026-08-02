import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/use_cases/join_flat_use_case.dart';
import 'join_flat_repository_provider.dart';

part 'join_flat_use_case_provider.g.dart';

@riverpod
JoinFlatUseCase joinFlatUseCase(Ref ref) {
  return JoinFlatUseCase(ref.watch(joinFlatRepositoryProvider));
}
