import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/dashboard/domain/entities/flat_entity.dart';
import 'dashboard_provider.dart';
import 'dashboard_repository_provider.dart';

part 'dashboard_flat_provider.g.dart';

@riverpod
Stream<FlatEntity?> dashboardFlat(Ref ref) {
  final flatId = ref.watch(
    firestoreUserProvider.select((user) => user.value?.flatId),
  );
  if (flatId == null || flatId.isEmpty) {
    return Stream.value(null);
  }

  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.watchFlat(flatId);
}
