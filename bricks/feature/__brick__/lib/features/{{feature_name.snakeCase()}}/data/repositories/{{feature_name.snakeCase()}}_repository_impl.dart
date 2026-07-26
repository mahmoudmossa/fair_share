import '../../domain/repositories/{{feature_name.snakeCase()}}_repository.dart';
import '../data_sources/{{feature_name.snakeCase()}}_remote_data_source.dart';

class {{feature_name.pascalCase()}}RepositoryImpl
    implements {{feature_name.pascalCase()}}Repository {
  final {{feature_name.pascalCase()}}RemoteDataSource _remoteDataSource;

  {{feature_name.pascalCase()}}RepositoryImpl(this._remoteDataSource);

  // TODO: Implement repository methods delegating to _remoteDataSource
}
