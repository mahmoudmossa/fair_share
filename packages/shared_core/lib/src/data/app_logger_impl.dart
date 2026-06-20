import 'package:logger/logger.dart';
import '../domain/app_logger.dart';

/// Default [AppLogger] implementation backed by the `logger` package.
///
/// The package's [PrettyPrinter] writes through `print()` which the Flutter
/// engine forwards to Android Logcat with the `flutter` tag - including in
/// release builds, which is exactly what this project needs.
class AppLoggerImpl implements AppLogger {
  AppLoggerImpl()
    : _logger = Logger(
        level: Level.debug,
        printer: PrettyPrinter(
          colors: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
          printEmojis: true,
        ),
      );

  final Logger _logger;

  @override
  void debug(String message) => _logger.d(message);

  @override
  void info(String message) => _logger.i(message);

  @override
  void warning(String message) => _logger.w(message);

  @override
  void error(String message, [Object? error, StackTrace? stack]) {
    _logger.e(message, error: error, stackTrace: stack);
  }
}
