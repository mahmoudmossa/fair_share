import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import '{{feature_name.snakeCase()}}_remote_data_source.dart';

part '{{feature_name.snakeCase()}}_remote_data_source_impl.g.dart';

class {{feature_name.pascalCase()}}RemoteDataSourceImpl
    implements {{feature_name.pascalCase()}}RemoteDataSource {
  final FirebaseFirestore _firestore;

  {{feature_name.pascalCase()}}RemoteDataSourceImpl(this._firestore);

  // TODO: Implement data source methods
}

@riverpod
{{feature_name.pascalCase()}}RemoteDataSource {{feature_name.camelCase()}}RemoteDataSource(Ref ref) {
  return {{feature_name.pascalCase()}}RemoteDataSourceImpl(
    ref.watch(firebaseFirestoreProvider),
  );
}
