import 'package:flutter/foundation.dart';
import 'package:patrol_finders/patrol_finders.dart';

abstract class BaseTestScenario {
  /// [$] is a [PatrolTester] instance.
  /// [next] is a [BaseTestScenario] instance.
  const BaseTestScenario(this.$, {required this.next});

  /// [next] is a [BaseTestScenario] instance.
  final BaseTestScenario? next;
  final PatrolTester $;

  /// [run] is a function that runs the test scenario.
  Future<bool> run();

  /// [waitAndCheckValid] is a function that waits for the test scenario to be valid.
  Future<bool> waitAndCheckValid();

  /// [startFlow] is a function that starts the flow.
  Future<void> startFlow() async {
    try {
      final isVisible = await waitAndCheckValid();
      if (isVisible) {
        await run();
      }
    } catch (e) {
      CustomLogger.showError<void>(e);
    } finally {
      if (next != null) {
        await next!.startFlow();
      }
    }
  }
}

class CustomLogger {
  static void showError<T>(dynamic error) {
    debugPrint('TEST ERROR: $error');
  }
}
