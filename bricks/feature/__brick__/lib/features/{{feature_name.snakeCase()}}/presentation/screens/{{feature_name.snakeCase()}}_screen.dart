{{#with_routing}}import 'package:auto_route/auto_route.dart';
{{/with_routing}}import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/{{feature_name.snakeCase()}}_actions_provider.dart';

{{#with_routing}}@RoutePage()
{{/with_routing}}class {{feature_name.pascalCase()}}Screen extends HookConsumerWidget {
  const {{feature_name.pascalCase()}}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // TODO: Watch your providers here
    // final state = ref.watch({{feature_name.camelCase()}}ActionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('{{feature_name.titleCase()}}'),
        backgroundColor: colorScheme.surface,
      ),
      body: const Center(
        child: Text('{{feature_name.titleCase()}} Screen'),
      ),
    );
  }
}
{{#with_routing}}
// ─────────────────────────────────────────────────────────────────
// TODO: Register this route in lib/core/router/app_router.dart
//
// 1. Add import:
//    import 'package:fair_share/features/{{feature_name.snakeCase()}}/presentation/screens/{{feature_name.snakeCase()}}_screen.dart';
//
// 2. Add to routes list:
//    AutoRoute(
//      path: '/{{feature_name.paramCase()}}',
//      page: {{feature_name.pascalCase()}}Route.page,
//      guards: [AuthGuard(ref: ref)], // remove guard if not needed
//    ),
//
// 3. Run build_runner to regenerate app_router.gr.dart:
//    dart run build_runner build --delete-conflicting-outputs
// ─────────────────────────────────────────────────────────────────
{{/with_routing}}
