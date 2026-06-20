import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_core/shared_core.dart';

/// Firebase-backed [CrashReporter] gateway.
class FirebaseCrashReporter implements CrashReporter {
  FirebaseCrashReporter({required this.flavor, required this._fallbackLogger});

  final Flavor flavor;
  final AppLogger _fallbackLogger;

  Future<void> configureCollection() async {
    try {
      _fallbackLogger.info('Configuring crash reporter for flavor: $flavor');
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      _fallbackLogger.info('Crash reporter collection enabled');
    } catch (e, s) {
      _fallbackLogger.error('Failed to configure crash reporter', e, s);
    }
  }

  @override
  Future<void> log(String message) async {
    try {
      await FirebaseCrashlytics.instance.log(message);
    } catch (e, s) {
      _fallbackLogger.error('Failed to log crash reporter breadcrumb', e, s);
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
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        fatal: fatal,
        reason: reason,
      );
    } catch (e, s) {
      _fallbackLogger.error('Failed to record crash reporter error', e, s);
    }
  }
}
