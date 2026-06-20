import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/injection_container.dart';

final appLoggerProvider = Provider<AppLogger>((ref) {
  return getIt<AppLogger>();
});
