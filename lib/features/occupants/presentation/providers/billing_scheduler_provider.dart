import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_flat_provider.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_repository_provider.dart';

part 'billing_scheduler_provider.g.dart';


class BillingTimerState {
  final DateTime targetDate;
  final Duration remainingDuration;
  final bool isCalculating;
  final String? lastExecutionStatus;

  const BillingTimerState({
    required this.targetDate,
    required this.remainingDuration,
    this.isCalculating = false,
    this.lastExecutionStatus,
  });

  BillingTimerState copyWith({
    DateTime? targetDate,
    Duration? remainingDuration,
    bool? isCalculating,
    String? lastExecutionStatus,
  }) {
    return BillingTimerState(
      targetDate: targetDate ?? this.targetDate,
      remainingDuration: remainingDuration ?? this.remainingDuration,
      isCalculating: isCalculating ?? this.isCalculating,
      lastExecutionStatus: lastExecutionStatus ?? this.lastExecutionStatus,
    );
  }
}

@riverpod
class BillingScheduler extends _$BillingScheduler {
  Timer? _timer;

  @override
  BillingTimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    final flatAsync = ref.watch(dashboardFlatProvider);
    final billingDay = flatAsync.value?.billingCalculationDay ?? 1;

    final target = _calculateNextTargetDate(billingDay);
    final now = DateTime.now();
    final initialRemaining = target.isAfter(now) ? target.difference(now) : Duration.zero;

    _startTimer();

    return BillingTimerState(
      targetDate: target,
      remainingDuration: initialRemaining,
    );
  }

  static DateTime _calculateNextTargetDate(int day) {
    final now = DateTime.now();
    final clampedDay = day.clamp(1, 28);

    var target = DateTime(now.year, now.month, clampedDay, 0, 1, 0);

    if (target.isBefore(now)) {
      target = DateTime(now.year, now.month + 1, clampedDay, 0, 1, 0);
    }
    return target;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final diff = state.targetDate.difference(now);

      if (diff.isNegative || diff == Duration.zero) {
        _timer?.cancel();
        state = state.copyWith(remainingDuration: Duration.zero);
        executeCalculation();
      } else {
        state = state.copyWith(remainingDuration: diff);
      }
    });
  }

  Future<void> executeCalculation() async {
    final flatId = ref.read(dashboardFlatProvider).value?.id;
    if (flatId == null || flatId.isEmpty) return;

    state = state.copyWith(isCalculating: true);
    try {
      await ref.read(dashboardRepositoryProvider).calculateMonthlyExpensesAndNotify(flatId);
      state = state.copyWith(
        isCalculating: false,
        lastExecutionStatus: 'Calculated successfully at ${DateTime.now().toIso8601String()}',
      );
    } catch (e) {
      state = state.copyWith(
        isCalculating: false,
        lastExecutionStatus: 'Failed: $e',
      );
    } finally {
      final billingDay = ref.read(dashboardFlatProvider).value?.billingCalculationDay ?? 1;
      final newTarget = _calculateNextTargetDate(billingDay);
      final now = DateTime.now();
      state = state.copyWith(
        targetDate: newTarget,
        remainingDuration: newTarget.difference(now),
      );
      _startTimer();
    }
  }


  void setTestCountdown(Duration duration) {
    _timer?.cancel();
    final testTarget = DateTime.now().add(duration);
    state = state.copyWith(
      targetDate: testTarget,
      remainingDuration: duration,
    );
    _startTimer();
  }
}
