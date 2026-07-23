import 'package:fair_share/core/config/env_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

@riverpod
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

/// Helper method to bind services to local Emulators if enabled
Future<void> configureFirebaseEmulators() async {
  if (!EnvConfig.useEmulators) return;
  final host = EnvConfig.emulatorHost;
  debugPrint('🔧 Configuring Firebase Emulators on host: $host');
  try {
    // 1. Auth Emulator (Default Port: 9099)
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);

    // 2. Firestore Emulator (Default Port: 8080)
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);

    // 3. (Optional) Database Emulator (Default Port: 9000)
    // FirebaseDatabase.instance.useDatabaseEmulator(host, 9000);

    debugPrint('✅ Firebase Emulators successfully initialized');
  } catch (e) {
    // Gracefully handle Hot Reload re-initialization attempts
    debugPrint(
      '⚠️ Firebase Emulators already initialized or failed to bind: $e',
    );
  }
}
