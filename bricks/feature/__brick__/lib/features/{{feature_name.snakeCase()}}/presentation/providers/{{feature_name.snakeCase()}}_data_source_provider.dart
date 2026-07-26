import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import '../../data/data_sources/{{feature_name.snakeCase()}}_remote_data_source.dart';
import '../../data/data_sources/{{feature_name.snakeCase()}}_remote_data_source_impl.dart';

part '{{feature_name.snakeCase()}}_data_source_provider.g.dart';

@riverpod
{{feature_name.pascalCase()}}RemoteDataSource {{feature_name.camelCase()}}RemoteDataSource(Ref ref) {
  return {{feature_name.pascalCase()}}RemoteDataSourceImpl(
    ref.watch(firebaseFirestoreProvider),
  );
}
