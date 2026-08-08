import 'dart:async';
import 'package:fair_share/core/modles/action_state.dart';
import 'package:fair_share/core/errors/failures.dart';
import 'package:fair_share/core/errors/server_failure_type.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import 'package:fair_share/features/notifications/presentation/providers/notifications_repository_provider.dart';
import 'package:fair_share/features/notifications/presentation/providers/push_notification_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_token_notifier.g.dart';

@Riverpod(keepAlive: true)
class FcmTokenNotifier extends _$FcmTokenNotifier {
  StreamSubscription<String>? _tokenSubscription;

  @override
  ActionState build() {
    ref.onDispose(() {
      _tokenSubscription?.cancel();
    });
    return const ActionState.initial();
  }


  Future<void> syncFcmToken() async {
    state = const ActionState.loading();
    try {
      final auth = await ref.read(authStateProvider.future);
      if (auth == null) {
        state = ActionState.failure(ServerFailure(ServerFailureType.unauthenticated));
        return;
      }

      final pushService = ref.read(pushNotificationServiceProvider);
      final repository = ref.read(notificationsRepositoryProvider);

      await pushService.initialize();
      final token = await pushService.getToken();

      if (token != null) {
        await repository.saveFcmToken(auth.id, token);
      }

      _tokenSubscription?.cancel();
      _tokenSubscription = pushService.onTokenRefresh.listen((newToken) async {
        await repository.saveFcmToken(auth.id, newToken);
      });

      state = const ActionState.success();
    } on Failure catch (failure) {
      state = ActionState.failure(failure);
    } catch (e) {
      state = ActionState.failure(ServerFailure(ServerFailureType.unknown));
    }
  }
}

