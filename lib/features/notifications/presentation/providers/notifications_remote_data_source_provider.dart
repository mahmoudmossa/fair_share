import 'package:fair_share/core/providers/firebase_providers.dart';
import 'package:fair_share/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:fair_share/features/notifications/data/data_sources/notifications_remote_data_source_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_remote_data_source_provider.g.dart';

@riverpod
NotificationsRemoteDataSource notificationsRemoteDataSource(Ref ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return NotificationsRemoteDataSourceImpl(firestore);
}

