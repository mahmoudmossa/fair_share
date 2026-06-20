import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_core/shared_core.dart';
import 'firebase_options.dart';
import 'package:fair_share/core/theme/app_theme.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Detect build flavor
  final String? rawFlavor = appFlavor;
  final Flavor flavor = rawFlavor == 'production' ? Flavor.production : Flavor.development;

  // Initialize all services via ServiceLocator
  await ServiceLocator().setup(flavor);

  final errorHandler = getIt<AppErrorHandler>();

  // Listen for uncaught Flutter errors
  FlutterError.onError = (FlutterErrorDetails details) {
    errorHandler.handle(details.exception, details.stack, context: 'FlutterError.onError');
  };

  // Listen for uncaught asynchronous or platform-channel errors
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorHandler.handle(error, stack, context: 'PlatformDispatcher.onError');
    return true;
  };

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const materialTheme = MaterialTheme(TextTheme());
    return MaterialApp(
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      home: const Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
