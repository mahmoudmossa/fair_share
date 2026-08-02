import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core/shared_core.dart';
import 'update_profile_name_use_case_provider.dart';
import 'update_profile_photo_use_case_provider.dart';

part 'profile_notifier_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  ActionState<void> build() {
    return const ActionInitial();
  }

  Future<void> updateDisplayName({
    required String userId,
    String? flatId,
    required String newName,
  }) async {
    state = const ActionLoading();
    try {
      final useCase = ref.read(updateProfileNameUseCaseProvider);
      await useCase(userId: userId, flatId: flatId, newName: newName);
      state = const ActionSuccess(null);
    } catch (error, stackTrace) {
      state = ActionError(error, stackTrace);
    }
  }

  Future<void> updateProfilePhoto({
    required String userId,
    String? flatId,
    required String base64Photo,
  }) async {
    state = const ActionLoading();
    try {
      final useCase = ref.read(updateProfilePhotoUseCaseProvider);
      await useCase(userId: userId, flatId: flatId, base64Photo: base64Photo);
      state = const ActionSuccess(null);
    } catch (error, stackTrace) {
      state = ActionError(error, stackTrace);
    }
  }
}
