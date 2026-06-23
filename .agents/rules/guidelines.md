---
trigger: always_on
---

# Flutter & Clean Architecture Developer Rules

You are an expert Flutter developer and software architect. When writing, refactoring, or reviewing Flutter code in this project, you MUST strictly adhere to the following architectural guidelines, principles, and tech stack constraints.

## 1. State Management (Riverpod & Hooks)
* **Code-Generated Riverpod:** ALWAYS use Riverpod code generation (`@riverpod` or `@Riverpod(keepAlive: true)`). Never write manual Providers unless absolutely necessary for external package integration.
* **Modern Notifiers:** Use the modern `Notifier` or `AsyncNotifier` classes (generated via `@riverpod`) for state management instead of the legacy `StateNotifier`.
* **ActionState Model:** Whenever handling server actions, mutations, or side-effects, wrap the response/state in the custom `ActionState` model to cleanly handle `loading`, `success`, and `error` states.
* **No StatefulWidgets:** AVOID using `StatefulWidget`. 
* **Use flutter_hooks:** For local, UI-level state that only matters within the `build` method (e.g., animations, local toggles), ALWAYS use `flutter_hooks`.
* **Hook Controllers:** ALWAYS use Hooks for managing controllers (e.g., `useTextEditingController()`, `useScrollController()`, `useAnimationController()`).
* **Base Widget:** By default, UI screens and components should extend `HookConsumerWidget` to access both hooks and Riverpod dependencies simultaneously.

## 2. Component Reusability & UI
* **The `shared_ui` Package:** If a custom UI component (button, card, text field, dialog) is used in more than one place, it MUST be extracted and placed into the dedicated `shared_ui` package/folder. Do not duplicate UI code across different features.
* **Widget Decomposition:** Keep `build` methods small. If a build method exceeds 60 lines, extract parts of it into separate, smaller stateless widgets. Do NOT extract UI into helper methods that return `Widget` (e.g., avoid `Widget _buildHeader() { ... }`).
* **No Hardcoded Colors:** NEVER use hardcoded color values (e.g., `Color(0xFF...)` or `Colors.green`) directly in UI widgets. Always retrieve colors dynamically from `Theme.of(context).colorScheme` (such as `colorScheme.primary`, `colorScheme.error`) to ensure proper support for styling, branding, and dark/light modes.

## 3. File Structure & Organization
* **Single Responsibility Files:** EVERY Provider must have its own dedicated file. Do not group multiple unrelated providers into a single `.dart` file.
* **Naming Conventions:** * Providers: `[feature_name]_provider.dart`
  * Screens: `[feature_name]_screen.dart`
  * Widgets: `[component_name]_widget.dart`

## 4. Coding Principles (Clean Code)
* **DRY (Don't Repeat Yourself):** Never duplicate logic. Extract shared logic into utility classes, repositories, or shared providers.
* **KISS (Keep It Simple, Stupid):** Avoid over-engineering. Write code that is easy to read and understand. Prefer readable code over clever, condensed code.
* **SOLID Principles:**
  * *Single Responsibility:* A class/widget should do one thing.
  * *Open/Closed:* Open for extension, closed for modification.
  * *Dependency Inversion:* Depend on abstractions (interfaces), not concrete implementations. Pass dependencies via Riverpod rather than instantiating them directly inside classes.

## 5. Additional Best Practices
* **Immutability:** All state classes and models MUST be immutable. Use the `freezed` package or standard `copyWith` methods to mutate state.
* **Error Handling:** Never swallow exceptions. Server calls must be wrapped in `try/catch` blocks, mapping errors explicitly to the `ActionState.error` state to be handled by the UI.
* **Null Safety:** Utilize strict null safety. Avoid using the `!` (bang) operator unless absolutely mathematically certain the value is not null. Use early returns and null-coalescing (`??`) instead.

## 6. Integration Testing (Patrol & Flow Architecture)
* **Key -> View -> Flow Pattern:** When testing UI screens and user journeys, ALWAYS structure tests using the `BaseTestScenario` chain of responsibility.
* **Chaining Scenarios:** Screens must be tested in sequence by passing the next scenario to run in the `next` constructor argument (e.g., `SplashTestScenario($, next: AuthTestScenario($, next: HomeTestScenario($, next: null)))`).
* **Mandatory Flow Addition:** Whenever a NEW screen or major feature is introduced, you MUST create a corresponding `BaseTestScenario` implementation for it and append it to the main application testing flow (e.g., `integration_test/app_flow_test.dart`). This prevents missing UI flows from coverage.
* **Testing Keys:** Ensure all interactive elements have unique and descriptive `Key` annotations (e.g. `Key('signInButton')`) to facilitate robust finder matches in tests.