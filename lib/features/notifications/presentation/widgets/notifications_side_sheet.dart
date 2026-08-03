import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/features/notifications/presentation/providers/watch_notifications_provider.dart';
import 'package:fair_share/features/notifications/presentation/providers/mark_notification_as_read_provider.dart';
import 'package:fair_share/features/notifications/presentation/providers/mark_all_notifications_as_read_provider.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import 'package:fair_share/features/notifications/presentation/widgets/notification_list_item_widget.dart';
class NotificationsSideSheet extends HookConsumerWidget {
  const NotificationsSideSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final notificationsAsync = ref.watch(watchNotificationsProvider);
    final authStateAsync = ref.watch(authStateProvider);

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.notifications_title.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  notificationsAsync.maybeWhen(
                    data: (notifications) {
                      final unreadCount = notifications.where((n) => !n.isRead).length;
                      if (unreadCount > 0) {
                        return IconButton(
                          key: Key(AppKeys.notifications.markAllReadButton),
                          icon: const Icon(Icons.done_all),
                          tooltip: LocaleKeys.notifications_mark_all_read.tr(),
                          onPressed: () {
                            authStateAsync.whenData((user) {
                              if (user != null) {
                                ref.read(markAllNotificationsAsReadProvider.notifier).markAllAsRead(userId: user.id);
                              }
                            });
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: notificationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text(error.toString())),
                data: (notifications) {
                  if (notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 64,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            LocaleKeys.notifications_empty.tr(),
                            style: TextStyle(
                              color: colorScheme.outline,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    key: Key(AppKeys.notifications.notificationListView),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationListItemWidget(
                        notification: notification,
                        onTap: () {
                          if (!notification.isRead) {
                            authStateAsync.whenData((user) {
                              if (user != null) {
                                ref.read(markNotificationAsReadProvider.notifier).markAsRead(
                                  userId: user.id,
                                  notificationId: notification.id,
                                );
                              }
                            });
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

