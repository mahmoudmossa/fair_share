import 'package:flutter/foundation.dart';
import 'package:patrol/patrol.dart'; // PatrolIntegrationTester lives here

abstract class BaseTestScenario {
  /// [$] is a [PatrolIntegrationTester] instance provided by patrolTest.
  /// [next] is the next scenario in the chain.
  const BaseTestScenario(this.$, {required this.next});

  final BaseTestScenario? next;

  /// PatrolIntegrationTester: the real-device tester from patrolTest.
  final PatrolIntegrationTester $;

  /// [run] executes the steps for this scenario's screen.
  Future<bool> run();

  /// [waitAndCheckValid] waits until this scenario's screen is visible.
  Future<bool> waitAndCheckValid();

  /// [startFlow] is the chain runner. It calls run(), then delegates to next.
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
