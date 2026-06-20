/// Single source of truth for crash reporting.
///
/// Concrete implementations wrap a vendor SDK (e.g. Firebase Crashlytics).
/// Per project policy every recorded error is treated as a crash, hence
/// `fatal` defaults to `true`.
abstract class CrashReporter {
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = true,
    String? reason,
  });

  Future<void> log(String message);
}
