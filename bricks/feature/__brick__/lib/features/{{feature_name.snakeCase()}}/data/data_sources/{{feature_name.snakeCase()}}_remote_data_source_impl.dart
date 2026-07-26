import 'package:cloud_firestore/cloud_firestore.dart';
import '{{feature_name.snakeCase()}}_remote_data_source.dart';

class {{feature_name.pascalCase()}}RemoteDataSourceImpl
    implements {{feature_name.pascalCase()}}RemoteDataSource {
  final FirebaseFirestore _firestore;

  {{feature_name.pascalCase()}}RemoteDataSourceImpl(this._firestore);

  // TODO: Implement data source methods
}
