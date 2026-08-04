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

  /// Base URL of the Vercel push-notification relay function.
  /// Pass at build time: --dart-define=PUSH_API_URL=https://your-project.vercel.app
  static const String pushApiUrl = String.fromEnvironment(
    'PUSH_API_URL',
    defaultValue: '',
  );

  /// Shared secret that the Vercel function expects in the x-fairshare-secret header.
  /// Pass at build time: --dart-define=PUSH_API_SECRET=your_random_secret
  static const String pushApiSecret = String.fromEnvironment(
    'PUSH_API_SECRET',
    defaultValue: '',
  );
}
