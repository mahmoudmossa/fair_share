import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_repository_provider.dart';
import 'package:fair_share/features/occupants/presentation/providers/billing_scheduler_provider.dart';

class BillingCalculationDayWidget extends HookConsumerWidget {
  final String flatId;
  final int initialDay;
  final bool isCurrentAdmin;

  const BillingCalculationDayWidget({
    super.key,
    required this.flatId,
    this.initialDay = 1,
    this.isCurrentAdmin = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedDay = useState<int>(initialDay);
    final isSaving = useState<bool>(false);
    final isSendingNotification = useState<bool>(false);

    final timerState = ref.watch(billingSchedulerProvider);
    final schedulerNotifier = ref.watch(billingSchedulerProvider.notifier);

    final daysRemaining = timerState.remainingDuration.inDays;
    final hoursRemaining = timerState.remainingDuration.inHours % 24;
    final minutesRemaining = timerState.remainingDuration.inMinutes % 60;
    final secondsRemaining = timerState.remainingDuration.inSeconds % 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Spinner & Countdown Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: timerState.isCalculating
                          ? null
                          : (secondsRemaining / 60.0),
                      strokeWidth: 5,
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                    Text(
                      '${secondsRemaining}s',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Calculation Countdown',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${daysRemaining}d ${hoursRemaining.toString().padLeft(2, '0')}h ${minutesRemaining.toString().padLeft(2, '0')}m ${secondsRemaining.toString().padLeft(2, '0')}s',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Target: Day ${selectedDay.value.toString().padLeft(2, '0')} @ 00:01',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Billing Calculation Day',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Day ${selectedDay.value.toString().padLeft(2, '0')}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Select the day of the month on which monthly expenses are calculated and billed to members.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        // 30 Days Month Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            final dayNumber = index + 1;
            final isSelected = selectedDay.value == dayNumber;

            return InkWell(
              onTap: isCurrentAdmin && !isSaving.value
                  ? () async {
                      selectedDay.value = dayNumber;
                      isSaving.value = true;
                      try {
                        await ref
                            .read(dashboardRepositoryProvider)
                            .updateBillingCalculationDay(flatId, dayNumber);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Calculation day set to Day ${dayNumber.toString().padLeft(2, '0')}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      } finally {
                        isSaving.value = false;
                      }
                    }
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    dayNumber.toString().padLeft(2, '0'),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // Test Section Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.science_outlined, size: 18, color: colorScheme.secondary),
                  const SizedBox(width: 8),
                  Text(
                    'Calculation Flow Test Section',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        schedulerNotifier.setTestCountdown(const Duration(seconds: 10));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Test timer set to 10 seconds! Watch countdown.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text('Set 10s Timer Test'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isSendingNotification.value || timerState.isCalculating
                          ? null
                          : () async {
                              isSendingNotification.value = true;
                              try {
                                await schedulerNotifier.executeCalculation();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Monthly cost calculated and notification sent to all members!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed: $e'),
                                      backgroundColor: colorScheme.error,
                                    ),
                                  );
                                }
                              } finally {
                                isSendingNotification.value = false;
                              }
                            },
                      icon: (isSendingNotification.value || timerState.isCalculating)
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.flash_on_rounded, size: 18),
                      label: const Text('Calculate Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

