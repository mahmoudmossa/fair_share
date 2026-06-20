import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  test('AppLoggerImpl creation', () {
    final logger = AppLoggerImpl();
    expect(logger, isNotNull);
  });
}
