import 'package:shared_core/shared_core.dart';
import 'package:fair_share/injection_container.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_error_handler_provider.g.dart';

@riverpod
AppErrorHandler appErrorHandler(Ref ref) {
  return getIt<AppErrorHandler>();
}
