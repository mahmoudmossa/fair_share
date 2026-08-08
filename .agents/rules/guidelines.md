<<<<<<< HEAD
---
trigger: always_on
---

# Flutter & Clean Architecture Developer Rules

You are an expert Flutter developer and software architect. When writing, refactoring, or reviewing Flutter code in this project, you MUST strictly adhere to the following architectural guidelines, principles, and tech stack constraints.

## 1. State Management (Riverpod & Hooks)
* **Code-Generated Riverpod:** ALWAYS use Riverpod code generation (`@riverpod` or `@Riverpod(keepAlive: true)`). Never write manual Providers (e.g. `Provider()`, `FutureProvider()`, or `StateNotifierProvider()`) unless absolutely necessary for external package integration.
* **Modern Notifiers:** Use the modern `Notifier` or `AsyncNotifier` classes (generated via `@riverpod`) for state management instead of the legacy `StateNotifier`.
* **ActionState Model:** Whenever handling server actions, mutations, or side-effects, wrap the response/state in the custom `ActionState` model to cleanly handle `loading`, `success`, and `error` states.
* **No StatefulWidgets:** AVOID using `StatefulWidget`. 
* **Use flutter_hooks:** For local, UI-level state that only matters within the `build` method (e.g., animations, local toggles), ALWAYS use `flutter_hooks`.
* **Hook Controllers:** ALWAYS use Hooks for managing controllers (e.g., `useTextEditingController()`, `useScrollController()`, `useAnimationController()`).
* **Base Widget:** By default, UI screens and components should extend `HookConsumerWidget` to access both hooks and Riverpod dependencies simultaneously.

## 2. Component Reusability & UI
* **The `shared_ui` Package:** If a custom UI component (button, card, text field, dialog) is used in more than one place, it MUST be extracted and placed into the dedicated `shared_ui` package/folder. Do not duplicate UI code across different features.
* **Widget Decomposition & Dedicated Files:** Keep `build` methods small. If a build method exceeds 60 lines, extract parts of it into separate, smaller stateless/consumer widgets. NEVER define private internal `Widget` classes (e.g. `class _HistoryLoadingWidget`) inside the same file as the main widget. Every extracted sub-widget MUST be placed into its own dedicated file inside the feature's `presentation/widgets/[feature_name]/` directory. Do NOT extract UI into helper methods that return `Widget` (e.g., avoid `Widget _buildHeader() { ... }`).
* **No Hardcoded Colors:** NEVER use hardcoded color values (e.g., `Color(0xFF...)` or `Colors.green`) directly in UI widgets. Always retrieve colors dynamically from `Theme.of(context).colorScheme` (such as `colorScheme.primary`, `colorScheme.error`) to ensure proper support for styling, branding, and dark/light modes.
* **No Hardcoded Strings:** NEVER use hardcoded user-facing strings directly in UI widgets. Always use localization (e.g. `AppLocalizations.of(context)` or equivalent context extension) after adding the appropriate translation keys.


## 3. File Structure & Organization
* **Single Responsibility Files:** EVERY Provider must have its own dedicated file. Do not group multiple unrelated providers into a single `.dart` file.
* **Naming Conventions:** * Providers: `[feature_name]_provider.dart`
  * Screens: `[feature_name]_screen.dart`
  * Widgets: `[component_name]_widget.dart`
* **Repository, Data Source & Use Case Provider Placement:** The Riverpod providers that instantiate a Repository (e.g. `flatRepositoryProvider`), a Data Source (e.g. `historyRemoteDataSourceProvider`), or a Use Case (e.g. `watchExpensesForMonthUseCaseProvider`) MUST be placed in dedicated single-responsibility files in the Presentation layer under `presentation/providers/` directory (e.g. `[feature_name]_repository_provider.dart`, `[feature_name]_remote_data_source_provider.dart`, `[use_case_name]_provider.dart`). Never define repository, data source, or use case providers inside the domain or data layer files (`domain/use_cases/`, `data/data_sources/`, or `data/repositories/`).

## 4. Coding Principles (Clean Code)
* **Decoupled Data Models (DTOs):** In strict Clean Architecture, Data Models/DTOs (like FlatDto) must not extend Domain Entities (like FlatEntity). They must be completely independent classes, using mapper methods (like toEntity() and fromEntity()) to convert between data structures. This prevents third-party serialization concerns (like json_serializable) from coupling to core domain logic.
* **DRY (Don't Repeat Yourself):** Never duplicate logic. Extract shared logic into utility classes, repositories, or shared providers.
* **KISS (Keep It Simple, Stupid):** Avoid over-engineering. Write code that is easy to read and understand. Prefer readable code over clever, condensed code.
* **SOLID Principles:**
  * *Single Responsibility:* A class/widget should do one thing.
  * *Open/Closed:* Open for extension, closed for modification.
  * *Dependency Inversion:* Depend on abstractions (interfaces), not concrete implementations. Pass dependencies via Riverpod rather than instantiating them directly inside classes.

## 5. Additional Best Practices
* **Immutability:** All state classes and models MUST be immutable. Use the `freezed` package or standard `copyWith` methods to mutate state.
* **Error Handling & Direct Async Return Types:** Never swallow exceptions. Server calls in Notifiers must be wrapped in `try/catch` blocks, mapping caught errors directly to `ActionState.error(e, stackTrace)` to be handled by the UI. Avoid wrapping repository or use-case return types in `Either<Exception, T>` or `Either<Failure, T>` unless explicitly required by architectural constraints. Prefer clean, direct async return signatures (`Future<T>` / `Future<void>`).
* **Null Safety:** Utilize strict null safety. Avoid using the `!` (bang) operator unless absolutely mathematically certain the value is not null. Use early returns and null-coalescing (`??`) instead.
* **Firebase Error Mapping & Active Research:** When integrating with Firebase, do not catch raw network exceptions (like `SocketException`) for Firestore operations. Firestore catches connection issues internally and propagates them as a `FirebaseException` with code `'unavailable'` or `'deadline-exceeded'`. You MUST inspect `e.code` to differentiate between database/security failures (`ServerFailure`) and network connection issues (`NetworkFailure`). Always search web documentation for up-to-date SDK behavior rather than assuming standard REST patterns.

## 6. Integration Testing (Patrol & Flow Architecture)
* **Key -> View -> Flow Pattern:** When testing UI screens and user journeys, ALWAYS structure tests using the `BaseTestScenario` chain of responsibility.
* **Chaining Scenarios:** Screens must be tested in sequence by passing the next scenario to run in the `next` constructor argument (e.g., `SplashTestScenario($, next: AuthTestScenario($, next: HomeTestScenario($, next: null)))`).
* **Mandatory Flow Addition:** Whenever a NEW screen or major feature is introduced, you MUST create a corresponding `BaseTestScenario` implementation for it and append it to the main application testing flow (e.g., `integration_test/app_flow_test.dart`). This prevents missing UI flows from coverage.
* **Testing Keys & Centralized Key Management:** Ensure all interactive elements have unique and descriptive `Key` annotations. ALL `Key` objects MUST be declared in dedicated feature key classes under `lib/core/constants/` (e.g. `history_keys.dart`) and exposed via the central `AppKeys` class (`AppKeys.history`). Never hardcode inline `Key('...')` strings directly in UI widgets or test scenarios.

## 7. Centralized Database Key & Constant Management
* **No Hardcoded Firestore/Database Keys:** NEVER hardcode Firestore collection names, document field keys, or database parameter strings directly as inline string literals in data sources or repositories. ALWAYS retrieve them from the central `FirestoreConstants` class (in `lib/core/constants/firestore_constants.dart`) or dedicated constant files.
=======
---
trigger: always_on
---

# Flutter & Clean Architecture Developer Rules

You are an expert Flutter developer and software architect. When writing, refactoring, or reviewing Flutter code in this project, you MUST strictly adhere to the following architectural guidelines, principles, and tech stack constraints.

## 1. State Management (Riverpod & Hooks)
* **Code-Generated Riverpod:** ALWAYS use Riverpod code generation (`@riverpod` or `@Riverpod(keepAlive: true)`). Never write manual Providers (e.g. `Provider()`, `FutureProvider()`, or `StateNotifierProvider()`) unless absolutely necessary for external package integration.
* **Modern Notifiers:** Use the modern `Notifier` or `AsyncNotifier` classes (generated via `@riverpod`) for state management instead of the legacy `StateNotifier`.
* **ActionState Model:** Whenever handling server actions, mutations, or side-effects, wrap the response/state in the custom `ActionState` model to cleanly handle `loading`, `success`, and `error` states.
* **No StatefulWidgets:** AVOID using `StatefulWidget`. 
* **Use flutter_hooks:** For local, UI-level state that only matters within the `build` method (e.g., animations, local toggles), ALWAYS use `flutter_hooks`.
* **Hook Controllers:** ALWAYS use Hooks for managing controllers (e.g., `useTextEditingController()`, `useScrollController()`, `useAnimationController()`).
* **Base Widget:** By default, UI screens and components should extend `HookConsumerWidget` to access both hooks and Riverpod dependencies simultaneously.
* **Awaiting Provider Futures:** When reading an async provider inside notifiers or actions, do NOT access `.value` synchronously (it could be null or uninitialized). Always await the provider's future directly (e.g. `final auth = await ref.read(authStateProvider.future);`).
* **Watching Notifier in Build:** When calling notifier methods from UI callback handlers (like `onPressed`), watch the notifier in the `build` method first, then call it from the callback. Do not use `ref.read` inside the callback for this.
  * *Example:* `final joinFlatNotifier = ref.watch(joinFlatNotifierProvider.notifier);` in `build`, then `onPressed: () => joinFlatNotifier.joinFlat(code)`.

## 2. Component Reusability & UI
* **The `shared_ui` Package:** If a custom UI component (button, card, text field, dialog) is used in more than one place, it MUST be extracted and placed into the dedicated `shared_ui` package/folder. Do not duplicate UI code across different features.
* **Widget Decomposition & Dedicated Files:** Keep `build` methods small. If a build method exceeds 60 lines, extract parts of it into separate, smaller stateless/consumer widgets. NEVER define private internal `Widget` classes (e.g. `class _HistoryLoadingWidget`) inside the same file as the main widget. Every extracted sub-widget MUST be placed into its own dedicated file inside the feature's `presentation/widgets/[feature_name]/` directory. Do NOT extract UI into helper methods that return `Widget` (e.g., avoid `Widget _buildHeader() { ... }`).
* **No Hardcoded Colors:** NEVER use hardcoded color values (e.g., `Color(0xFF...)` or `Colors.green`) directly in UI widgets. Always retrieve colors dynamically from `Theme.of(context).colorScheme` (such as `colorScheme.primary`, `colorScheme.error`) to ensure proper support for styling, branding, and dark/light modes.
* **No Hardcoded Strings:** NEVER use hardcoded user-facing strings directly in UI widgets. Always use localization (e.g. `AppLocalizations.of(context)` or equivalent context extension) after adding the appropriate translation keys.


## 3. File Structure & Organization
* **Single Responsibility Files:** EVERY Provider must have its own dedicated file. Do not group multiple unrelated providers into a single `.dart` file.
* **Naming Conventions:** * Providers: `[feature_name]_provider.dart`
  * Screens: `[feature_name]_screen.dart`
  * Widgets: `[component_name]_widget.dart`
* **Repository, Data Source & Use Case Provider Placement:** The Riverpod providers that instantiate a Repository (e.g. `flatRepositoryProvider`), a Data Source (e.g. `historyRemoteDataSourceProvider`), or a Use Case (e.g. `watchExpensesForMonthUseCaseProvider`) MUST be placed in dedicated single-responsibility files in the Presentation layer under `presentation/providers/` directory (e.g. `[feature_name]_repository_provider.dart`, `[feature_name]_remote_data_source_provider.dart`, `[use_case_name]_provider.dart`). Never define repository, data source, or use case providers inside the domain or data layer files (`domain/use_cases/`, `data/data_sources/`, or `data/repositories/`).

## 4. Coding Principles (Clean Code)
* **Decoupled Data Models (DTOs):** In strict Clean Architecture, Data Models/DTOs (like FlatDto) must not extend Domain Entities (like FlatEntity). They must be completely independent classes, using mapper methods (like toEntity() and fromEntity()) to convert between data structures. Furthermore, Data Sources (`RemoteDataSource` / `LocalDataSource`) MUST operate exclusively on DTOs/Data Models and MUST NEVER import or accept/return Domain Entities (`Entity`). Mapping between DTOs and Entities MUST strictly occur inside the Repository layer (`RepositoryImpl`).

* **DRY (Don't Repeat Yourself):** Never duplicate logic. Extract shared logic into utility classes, repositories, or shared providers.
* **KISS (Keep It Simple, Stupid):** Avoid over-engineering. Write code that is easy to read and understand. Prefer readable code over clever, condensed code.
* **No Either Type for Failures:** Avoid using `Either` (e.g. from `dartz` or `fpdart`) to represent error/success flow. Return direct types (`Future<void>`, `Future<T>`) and throw errors or custom `Failure` objects directly. Riverpod Notifiers should handle exceptions via `try/catch` blocks and assign them directly to `ActionState.failure(failure)`.
* **No Monolithic State Streams:** NEVER bundle unrelated sub-collection streams or multiple UI feature queries into a single monolithic state stream (e.g. `DashboardState`). Each UI section (e.g. expenses, debts, activity feed) MUST have its own dedicated, single-responsibility stream and provider to keep state updates isolated, efficient, and easy to maintain.
* **No Hardcoded Fallback Values for Null/Missing Firestore Data:** NEVER hardcode arbitrary static fallback values (such as `?? 85.0` or default string names) when document fields or whole documents are missing or nullable in Firestore. Nullable domain data MUST remain nullable until authoritative data is received from the backend/database.
>>>>>>> origin/main

