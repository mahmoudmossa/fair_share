import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
}

class PushNotificationService {
  final FirebaseMessaging _messaging;

  PushNotificationService(this._messaging);

  Future<NotificationSettings> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('User notification permission status: ${settings.authorizationStatus}');
    return settings;
  }

  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      debugPrint('FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
      return null;
    }
  }

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  Future<void> initialize({
    Function(RemoteMessage)? onForegroundMessage,
    Function(RemoteMessage)? onNotificationOpenedApp,
  }) async {
    // Request permission
    await requestPermission();

    // Set foreground presentation options (for iOS / Android foreground alerts)
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Set background messaging handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground FCM message: ${message.notification?.title}');
      if (onForegroundMessage != null) {
        onForegroundMessage(message);
      }
    });

    // Listen to notification tap events when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification opened app from background: ${message.data}');
      if (onNotificationOpenedApp != null) {
        onNotificationOpenedApp(message);
      }
    });

    // Check if app was opened from a terminated state via a notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null && onNotificationOpenedApp != null) {
      debugPrint('Notification opened app from terminated state: ${initialMessage.data}');
      onNotificationOpenedApp(initialMessage);
    }
  }
}
