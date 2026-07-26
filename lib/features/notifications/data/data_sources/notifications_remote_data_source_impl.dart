import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'notifications_remote_data_source.dart';

part 'notifications_remote_data_source_impl.g.dart';

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final FirebaseFirestore _firestore;

  NotificationsRemoteDataSourceImpl(this._firestore);

  // TODO: Implement data source methods
}

@riverpod
NotificationsRemoteDataSource notificationsRemoteDataSource(Ref ref) {
  return NotificationsRemoteDataSourceImpl(
    ref.watch(firebaseFirestoreProvider),
  );
}
