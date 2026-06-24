import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:fair_share/core/router/app_router.dart';
import 'package:fair_share/features/auth/domain/entities/user_entity.dart';
import 'package:fair_share/features/auth/presentation/provider/auth_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGuard extends AutoRouteGuard {
  final Ref ref;
  AuthGuard({required this.ref});

  @override
  FutureOr<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final UserEntity? authState = await ref.read(authStateProvider.future);
    if (authState != null) {
      resolver.next();
    } else {
      router.replaceAll([LoginRoute()]);
    }
  }
}
