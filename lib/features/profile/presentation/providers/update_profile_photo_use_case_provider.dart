import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/profile/domain/use_cases/update_profile_photo_use_case.dart';
import 'profile_repository_provider.dart';

part 'update_profile_photo_use_case_provider.g.dart';

@riverpod
UpdateProfilePhotoUseCase updateProfilePhotoUseCase(Ref ref) {
  return UpdateProfilePhotoUseCase(ref.watch(profileRepositoryProvider));
}
