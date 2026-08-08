import 'package:fair_share/features/dashboard/domain/entities/activity_entity.dart';
import 'package:fair_share/features/dashboard/domain/repositories/dashboard_repository.dart';

class WatchActivitiesUseCase {
  final DashboardRepository _repository;

  WatchActivitiesUseCase(this._repository);

  Stream<List<ActivityEntity>> call(String flatId) {
    return _repository.watchActivities(flatId);
  }
}
