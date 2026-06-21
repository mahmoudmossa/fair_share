import 'package:shared_core/shared_core.dart';
import 'package:fair_share/injection_container.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crash_reporter_provider.g.dart';

@riverpod
CrashReporter crashReporter(Ref ref) {
  return getIt<CrashReporter>();
}
