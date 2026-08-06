import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/dashboard/domain/entities/billing_cycle_entity.dart';
import 'dashboard_provider.dart';
import 'dashboard_repository_provider.dart';

part 'active_billing_cycle_provider.g.dart';

@riverpod
Stream<BillingCycleEntity?> activeBillingCycle(Ref ref) {
  final flatId = ref.watch(
    firestoreUserProvider.select((user) => user.value?.flatId),
  );
  if (flatId == null || flatId.isEmpty) {
    return Stream.value(null);
  }

  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.watchActiveBillingCycle(flatId);
}
