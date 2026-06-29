import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:fair_share/core/router/app_router.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_notifier_provider.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';

class AuthGuard extends AutoRouteGuard {
  final Ref ref;
  AuthGuard({required this.ref});

  @override
  FutureOr<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    // 1. Check if we just logged in via the login screen notifier
    final authNotifierState = ref.read(authProvider);
    if (authNotifierState is ActionSuccess<UserEntity?> && authNotifierState.data != null) {
      resolver.next();
      return;
    }

    // 2. Otherwise, check authStateProvider (e.g. on app startup or page refresh)
    final UserEntity? authState = await ref.read(authStateProvider.future);
    if (authState != null) {
      resolver.next();
    } else {
      router.replaceAll([LoginRoute()]);
    }
  }
}
