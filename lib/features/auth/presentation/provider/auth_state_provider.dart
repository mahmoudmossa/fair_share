import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/auth_state_changes_use_case.dart';

part 'auth_state_provider.g.dart';

@riverpod
Stream<UserEntity?> authState(Ref ref) {
  final useCase = ref.watch(authStateChangesUseCaseProvider);
  return useCase();
}
