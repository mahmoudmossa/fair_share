import 'dart:ui';
import 'package:fair_share/core/providers/firebase_providers.dart';
import 'package:fair_share/core/router/providers/app_router_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_core/shared_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'firebase_options.dart';
import 'package:fair_share/core/theme/app_theme.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize easy_localization
  await EasyLocalization.ensureInitialized();

  // Initialize Firebase options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // 2. Configure Local Emulators immediately after SDK init if USE_EMULATORS=true
  await configureFirebaseEmulators();
  // Detect build flavor
  final String? rawFlavor = appFlavor;
  final Flavor flavor = rawFlavor == 'production'
      ? Flavor.production
      : Flavor.development;

  // Initialize all services via ServiceLocator
  await ServiceLocator().setup(flavor);

  final errorHandler = getIt<AppErrorHandler>();

  // Listen for uncaught Flutter errors
  FlutterError.onError = (FlutterErrorDetails details) {
    errorHandler.handle(
      details.exception,
      details.stack,
      context: 'FlutterError.onError',
    );
  };

  // Listen for uncaught asynchronous or platform-channel errors
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorHandler.handle(error, stack, context: 'PlatformDispatcher.onError');
    return true;
  };

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('de')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: ProviderScope(child: MainApp()),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appAutoRouter = ref.watch(appRouterProvider);
    const materialTheme = MaterialTheme(TextTheme());
    return MaterialApp.router(
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appAutoRouter.config(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
