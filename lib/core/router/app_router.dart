import 'package:auto_route/auto_route.dart';
import 'package:fair_share/features/auth/presentation/screens/login_screen.dart';
import 'package:fair_share/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:fair_share/features/dashboard/presentation/screens/join_or_create_flat_screen.dart';
import 'package:fair_share/features/new_flat/presentation/screens/new_flat_screen.dart';
import 'package:fair_share/core/router/guards/auth_guard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final Ref ref;
  AppRouter(this.ref);
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/login', page: LoginRoute.page, initial: true),
    AutoRoute(
      path: '/dashboard',
      page: DashboardRoute.page,
      guards: [AuthGuard(ref: ref)],
    ),
    AutoRoute(
      path: '/flat-setup',
      page: JoinOrCreateFlatRoute.page,
      guards: [AuthGuard(ref: ref)],
    ),
    AutoRoute(
      path: '/create-flat',
      page: NewFlatRoute.page,
      guards: [AuthGuard(ref: ref)],
    ),
  ];
}
