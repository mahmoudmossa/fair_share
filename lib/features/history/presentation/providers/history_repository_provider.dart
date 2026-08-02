import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/history/domain/repositories/history_repository.dart';
import 'package:fair_share/features/history/data/repositories/history_repository_impl.dart';
import 'history_remote_data_source_provider.dart';

part 'history_repository_provider.g.dart';

@Riverpod(keepAlive: true)
HistoryRepository historyRepository(Ref ref) {
  return HistoryRepositoryImpl(ref.watch(historyRemoteDataSourceProvider));
}
