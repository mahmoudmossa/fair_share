import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/features/notifications/domain/entities/notifications_entity.dart';
import 'package:fair_share/features/notifications/domain/entities/notification_type.dart';

class NotificationListItemWidget extends StatelessWidget {
  const NotificationListItemWidget({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationsEntity notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    IconData getIconData() {
      switch (notification.type) {
        case NotificationType.settle:
          return Icons.check_circle_outline;
        case NotificationType.expenseAdded:
          return Icons.receipt_long_outlined;
        case NotificationType.calculationDayChanged:
          return Icons.event_outlined;
        case NotificationType.costsCalculated:
          return Icons.calculate_outlined;
        case NotificationType.unknown:
          return Icons.notifications_outlined;
      }
    }

    String getTranslatedTitle() {
      switch (notification.title) {
        case 'dashboard_notification_settled_title':
          return LocaleKeys.notifications_dashboard_notification_settled_title.tr();
        case 'dashboard_notification_expense_added_title':
          return LocaleKeys.notifications_dashboard_notification_expense_added_title.tr();
        case 'dashboard_notification_billing_day_title':
          return LocaleKeys.notifications_dashboard_notification_billing_day_title.tr();
        case 'dashboard_notification_costs_calculated_title':
          return LocaleKeys.notifications_dashboard_notification_costs_calculated_title.tr();
        default:
          return notification.title;
      }
    }

    String getTranslatedBody() {
      final parts = notification.body.split('|');
      final key = parts.first;
      final args = parts.length > 1 ? parts.sublist(1) : <String>[];

      switch (key) {
        case 'dashboard_notification_settled_body':
          return LocaleKeys.notifications_dashboard_notification_settled_body.tr(args: args);
        case 'dashboard_notification_expense_added_body':
          return LocaleKeys.notifications_dashboard_notification_expense_added_body.tr(args: args);
        case 'dashboard_notification_billing_day_body':
          return LocaleKeys.notifications_dashboard_notification_billing_day_body.tr(args: args);
        case 'dashboard_notification_costs_calculated_body':
          return LocaleKeys.notifications_dashboard_notification_costs_calculated_body.tr(args: args);
        default:
          return notification.body;
      }
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        color: notification.isRead ? Colors.transparent : colorScheme.primaryContainer.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                getIconData(),
                color: notification.isRead ? colorScheme.onSurfaceVariant : colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          getTranslatedTitle(),
                          style: TextStyle(
                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      // Timeago requires timestamp, but NotificationsEntity doesn't have it exposed right now in the plan.
                      // Wait, I should add timestamp to NotificationsEntity if we need it. 
                      // Actually let me just omit the timeago for now since the DTO drops it on conversion.
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    getTranslatedBody(),
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
