import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/new_flat/domain/entities/flat_member_entity.dart';
import 'dashboard_provider.dart';
import 'dashboard_repository_provider.dart';

part 'flat_members_provider.g.dart';

@riverpod
Stream<List<FlatMemberEntity>> flatMembers(Ref ref) {
  final flatId = ref.watch(
    firestoreUserProvider.select((user) => user.value?.flatId),
  );
  if (flatId == null || flatId.isEmpty) {
    return Stream.value(const []);
  }

  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.watchFlatMembers(flatId);
}
