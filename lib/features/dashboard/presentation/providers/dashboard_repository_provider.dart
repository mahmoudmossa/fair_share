import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../data/data_sources/dashboard_remote_data_source_impl.dart';

part 'dashboard_repository_provider.g.dart';

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  return DashboardRepositoryImpl(ref.watch(dashboardRemoteDataSourceProvider));
}
