import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../domain/app_logger.dart';
import '../domain/crash_reporter.dart';
import '../domain/flavor.dart';

/// Firebase-backed [CrashReporter] gateway.
class FirebaseCrashReporter implements CrashReporter {
  FirebaseCrashReporter({
    required this.flavor,
    required this.fallbackLogger,
    required this.crashlytics,
  });

  final Flavor flavor;
  final AppLogger fallbackLogger;
  final FirebaseCrashlytics crashlytics;

  Future<void> configureCollection() async {
    try {
      fallbackLogger.info('Configuring crash reporter for flavor: $flavor');
      await crashlytics.setCrashlyticsCollectionEnabled(true);
      fallbackLogger.info('Crash reporter collection enabled');
    } catch (e, s) {
      fallbackLogger.error('Failed to configure crash reporter', e, s);
    }
  }

  @override
  Future<void> log(String message) async {
    try {
      await crashlytics.log(message);
    } catch (e, s) {
      fallbackLogger.error('Failed to log crash reporter breadcrumb', e, s);
    }
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = true,
    String? reason,
  }) async {
    try {
      await crashlytics.recordError(
        error,
        stack,
        fatal: fatal,
        reason: reason,
      );
    } catch (e, s) {
      fallbackLogger.error('Failed to record crash reporter error', e, s);
    }
  }
}
