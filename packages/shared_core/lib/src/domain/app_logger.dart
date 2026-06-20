/// Single source of truth for runtime logging.
///
/// Implementations must use a sink that is visible in Android Logcat in
/// release builds (e.g. the `logger` package which forwards to `print()`).
/// `dart:developer.log` is filtered out in release mode and must not be used.
abstract class AppLogger {
  void debug(String message);

  void info(String message);

  void warning(String message);

  void error(String message, [Object? error, StackTrace? stack]);
}
