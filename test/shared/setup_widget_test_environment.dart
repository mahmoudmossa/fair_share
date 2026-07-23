import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';

void setupWidgetTestEnvironment() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
  });
}
