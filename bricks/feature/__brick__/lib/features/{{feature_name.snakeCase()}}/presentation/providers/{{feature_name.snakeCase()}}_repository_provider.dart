import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/{{feature_name.snakeCase()}}_repository.dart';
import '../../data/repositories/{{feature_name.snakeCase()}}_repository_impl.dart';
import '{{feature_name.snakeCase()}}_data_source_provider.dart';

part '{{feature_name.snakeCase()}}_repository_provider.g.dart';

@riverpod
{{feature_name.pascalCase()}}Repository {{feature_name.camelCase()}}Repository(Ref ref) {
  return {{feature_name.pascalCase()}}RepositoryImpl(
    ref.watch({{feature_name.camelCase()}}RemoteDataSourceProvider),
  );
}
