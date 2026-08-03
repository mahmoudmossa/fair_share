import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fair_share/core/constants/app_keys.dart';
import 'package:fair_share/features/notifications/presentation/providers/watch_notifications_provider.dart';

class NotificationIconWidget extends ConsumerWidget {
  const NotificationIconWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(watchNotificationsProvider);

    void showNotifications() {
      Scaffold.of(context).openEndDrawer();
    }

    return notificationsAsync.when(
      data: (notifications) {
        final unreadCount = notifications.where((n) => !n.isRead).length;

        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              key: Key(AppKeys.notifications.notificationIconButton),
              icon: const Icon(Icons.notifications_outlined),
              onPressed: showNotifications,
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => IconButton(
        key: Key(AppKeys.notifications.notificationIconButton),
        icon: const Icon(Icons.notifications_outlined),
        onPressed: showNotifications,
      ),
      error: (err, stack) {
        debugPrint('Error loading notifications: $err');
        return IconButton(
          key: Key(AppKeys.notifications.notificationIconButton),
          icon: const Icon(Icons.notifications_outlined),
          onPressed: showNotifications,
        );
      },
    );
  }
}
