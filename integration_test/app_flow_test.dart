import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:patrol/patrol.dart';
import 'package:fair_share/main.dart' as app;
import 'package:fair_share/features/auth/data/repositories/auth_repository_impl.dart';
import 'support/fake_auth_repository.dart';
import 'scenarios/login_test_scenario.dart';

void main() async {
  patrolWidgetTest(
    'Initial App Module Test Flow',
    ($) async {
      await EasyLocalization.ensureInitialized();
      final fakeAuthRepository = FakeAuthRepository();

      // Pump the main app wrapped with EasyLocalization and ProviderScope
      await $.pumpWidgetAndSettle(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('de')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWith((ref) => fakeAuthRepository),
            ],
            child: app.MainApp(),
          ),
        ),
      );

      // Setup the scenario flow (chain of responsibility) with only Login scenario
      final loginScenario = LoginTestScenario($, next: null);

      // Execute the test flow starting from the Login Screen
      await loginScenario.startFlow();
    },
  );
}
