import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:fair_share/injection_container.dart';

final crashReporterProvider = Provider<CrashReporter>((ref) {
  return getIt<CrashReporter>();
});
