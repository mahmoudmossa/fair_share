import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/use_cases/update_profile_name_use_case.dart';
import 'profile_repository_provider.dart';

part 'update_profile_name_use_case_provider.g.dart';

@riverpod
UpdateProfileNameUseCase updateProfileNameUseCase(Ref ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return UpdateProfileNameUseCase(repository);
}
