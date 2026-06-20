import 'app_logger.dart';
import 'crash_reporter.dart';

/// Central pipeline that turns any error into a Logcat-visible log line and
/// a fatal Crashlytics event. This is the only Flutter-side path that should
/// be used for handling exceptions and should never be bypassed by direct
/// `FirebaseCrashlytics.instance` or `dart:developer.log` calls.
class AppErrorHandler {
  AppErrorHandler(this.logger, this.crashReporter);

  final AppLogger logger;
  final CrashReporter crashReporter;

  Future<void> handle(
    Object error,
    StackTrace? stack, {
    String? context,
  }) async {
    final StackTrace effectiveStack = stack ?? StackTrace.current;
    final String label = context ?? '-';
    logger.error('Error in $label: $error', error, effectiveStack);
    await crashReporter.recordError(error, effectiveStack, reason: context);
  }
}
