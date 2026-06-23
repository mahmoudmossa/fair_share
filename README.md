# FairShare WG App

A modern, automated flatmate expense sharing and billing application for iOS and Android, built with Flutter, Riverpod, and Firebase.

---

## Technical Stack & Architecture

- **Frontend:** Flutter
- **State Management:** Riverpod (code-generated `Notifier`/`AsyncNotifier`) & `flutter_hooks` (for local UI state)
- **Database & Authentication:** Firebase (Auth, Firestore, Cloud Messaging, Crashlytics)
- **Local Package Structure:**
  - `packages/design_system`: Theme definitions, Typography, and styling details.
  - `packages/shared_core`: Shared domain errors, exceptions, models, and interfaces (like `AppLogger`, `CrashReporter`).
  - `packages/shared_ui`: Extracted, reusable styled widgets (buttons, cards, inputs).

---

## Integration Testing Architecture (Key -> View -> Flow)

To ensure high-quality UI coverage and represent correct user journeys, FairShare uses a chainable end-to-end integration testing pattern powered by [Patrol](https://patrol.leancode.co/).

### 1. The Design Pattern

Tests are split into individual **Scenarios** that represent specific views/screens. These scenarios are chained sequentially using the Chain of Responsibility design pattern.

Each scenario implements `BaseTestScenario`:

```dart
abstract class BaseTestScenario {
  const BaseTestScenario(this.$, {required this.next});

  final BaseTestScenario? next;
  final PatrolTester $;

  /// Validates that this screen/scenario is currently visible.
  Future<bool> waitAndCheckValid();

  /// Runs the interactions on this screen (entering text, clicking buttons).
  Future<bool> run();

  /// Executes the current scenario and triggers the next one in the chain.
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
```

### 2. Creating a Scenario

To test a screen, extend `BaseTestScenario` and define `waitAndCheckValid` and `run`:

```dart
class AuthTestScenario extends BaseTestScenario {
  const AuthTestScenario(super.$, {required super.next});

  @override
  Future<bool> waitAndCheckValid() async {
    await $(const Key('emailField')).waitUntilVisible();
    return true;
  }

  @override
  Future<bool> run() async {
    await $(const Key('emailField')).enterText('user@example.com');
    await $(const Key('passwordField')).enterText('password123');
    await $(const Key('signInButton')).tap();
    await $.tester.pumpAndSettle();
    return true;
  }
}
```

### 3. Chaining Scenarios in a Flow

All scenarios are wired sequentially in `integration_test/app_flow_test.dart`:

```dart
void main() {
  patrolWidgetTest(
    'Initial App Module Test Flow',
    ($) async {
      // Initialize fake/mock dependencies (e.g. FakeAuthRepository)
      // and pump the application.
      
      final homeScenario = HomeTestScenario($, next: null);
      final authScenario = AuthTestScenario($, next: homeScenario);
      final splashScenario = SplashTestScenario($, next: authScenario);

      // Start the flow
      await splashScenario.startFlow();
    },
  );
}
```

### 4. Rules for Developers

- **Rule 1:** When creating a new screen or major feature, you **MUST** create a corresponding scenario class extending `BaseTestScenario`.
- **Rule 2:** Append your scenario into the main integration testing flow in `integration_test/app_flow_test.dart` to prevent test gaps.
- **Rule 3:** All interactive widgets (inputs, buttons, tap targets) must be annotated with a descriptive `Key` to allow robust test finders.

---

## Running Integration Tests

To run the Patrol integration tests, use the following command:

```bash
fvm patrol test --target integration_test/app_flow_test.dart
```
