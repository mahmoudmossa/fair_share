import 'package:shared_core/shared_core.dart';
import 'package:fair_share/injection_container.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_logger_provider.g.dart';

@riverpod
AppLogger appLogger(Ref ref) {
  return getIt<AppLogger>();
}
