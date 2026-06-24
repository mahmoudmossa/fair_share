import 'package:auto_route/auto_route.dart';
import 'package:fair_share/features/auth/presentation/screens/login_screen.dart';
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
  ];
}
