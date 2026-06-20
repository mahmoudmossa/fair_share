import 'package:get_it/get_it.dart';
import 'package:shared_core/shared_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final GetIt getIt = GetIt.instance;

// how to use
// Future.wait([
//    ServiceLocator().setup(flavor),
//    ]).then((value) {
//    runApp(const MyApp());
//    });
class ServiceLocator {
  Future<void> setup(Flavor flavor) async {
    final logger = AppLoggerImpl();
    final crashReporter = FirebaseCrashReporter(
      flavor: flavor,
      fallbackLogger: logger,
      crashlytics: FirebaseCrashlytics.instance,
    );
    await crashReporter.configureCollection();

    getIt.registerSingleton<AppLogger>(logger);
    getIt.registerSingleton<CrashReporter>(crashReporter);
    getIt.registerSingleton<AppErrorHandler>(
      AppErrorHandler(logger, crashReporter),
    );
  }
}
