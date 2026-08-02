// presentation/providers/notifications_data_source_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import '../../data/data_sources/notifications_remote_data_source.dart';
import '../../data/data_sources/notifications_remote_data_source_impl.dart';

part 'notifications_data_source_provider.g.dart';

@riverpod
NotificationsRemoteDataSource notificationsRemoteDataSource(Ref ref) {
  return NotificationsRemoteDataSourceImpl(
    ref.watch(firebaseFirestoreProvider),
  );
}
