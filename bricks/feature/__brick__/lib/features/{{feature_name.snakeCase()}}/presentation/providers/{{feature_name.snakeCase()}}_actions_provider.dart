import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_core/shared_core.dart';
import '{{feature_name.snakeCase()}}_repository_provider.dart';

part '{{feature_name.snakeCase()}}_actions_provider.g.dart';

@riverpod
class {{feature_name.pascalCase()}}Actions extends _${{feature_name.pascalCase()}}Actions {
  @override
  ActionState<void> build() {
    return const ActionInitial();
  }

  // TODO: Add action methods that call repository methods.
  // Example:
  // Future<void> doSomething({required String id}) async {
  //   state = const ActionLoading();
  //   final repository = ref.read({{feature_name.camelCase()}}RepositoryProvider);
  //   final result = await repository.doSomething(id);
  //   state = result.fold(
  //     (error) => ActionError(error),
  //     (_) => const ActionSuccess(null),
  //   );
  // }
}
