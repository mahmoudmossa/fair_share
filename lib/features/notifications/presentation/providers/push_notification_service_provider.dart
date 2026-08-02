import 'package:fair_share/core/providers/firebase_messaging_provider.dart';
import 'package:fair_share/features/notifications/data/services/push_notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_notification_service_provider.g.dart';

@riverpod
PushNotificationService pushNotificationService(Ref ref) {
  final messaging = ref.watch(firebaseMessagingProvider);
  return PushNotificationService(messaging);
}
