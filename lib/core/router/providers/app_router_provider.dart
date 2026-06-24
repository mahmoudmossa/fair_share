import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fair_share/core/router/app_router.dart';

part 'app_router_provider.g.dart';

@riverpod
AppRouter appRouter(Ref ref) {
  // We pass the ref to the router, which passes it to the AuthGuard
  return AppRouter(ref);
}
