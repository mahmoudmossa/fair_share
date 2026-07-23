import 'dart:io';
import 'package:flutter/foundation.dart';

class EnvConfig {
  /// Toggle to determine if Firebase Emulators should be used
  static const bool useEmulators = bool.fromEnvironment(
    'USE_EMULATORS',
    defaultValue: false,
  );

  /// Automatically resolves the correct local loopback address based on platform
  static String get emulatorHost {
    if (kIsWeb) {
      return 'localhost';
    }
    // Android emulator routes to host machine via 10.0.2.2, while iOS/macOS use localhost
    return Platform.isAndroid ? '10.0.2.2' : 'localhost';
  }
}
