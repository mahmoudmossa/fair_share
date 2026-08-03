import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fair_share/features/dashboard/presentation/providers/dashboard_repository_provider.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        // Send Cost Notification Test Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: isSendingNotification.value
                ? null
                : () async {
                    isSendingNotification.value = true;
                    try {
                      await ref
                          .read(dashboardRepositoryProvider)
                          .calculateMonthlyExpensesAndNotify(flatId);
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
            icon: isSendingNotification.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded),
            label: const Text('Send Cost Notification'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
