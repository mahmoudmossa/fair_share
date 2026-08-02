import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'package:fair_share/features/history/data/data_sources/history_remote_data_source.dart';
import 'package:fair_share/features/history/data/data_sources/history_remote_data_source_impl.dart';

part 'history_remote_data_source_provider.g.dart';

@riverpod
HistoryRemoteDataSource historyRemoteDataSource(Ref ref) {
  return HistoryRemoteDataSourceImpl(ref.watch(firebaseFirestoreProvider));
}
