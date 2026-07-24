import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class SynchronousAssetLoader extends AssetLoader {
  const SynchronousAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final file = File('$path/${locale.languageCode}.json');
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      return jsonDecode(content) as Map<String, dynamic>;
    }
    return {};
  }
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpLocalizedWidget(
    Widget widget, {
    List<Override> overrides = const [],
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('de')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          assetLoader: const SynchronousAssetLoader(),
          child: Builder(
            builder: (context) {
              return MaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: widget,
              );
            },
          ),
        ),
      ),
    );
    await pumpAndSettle();
  }
}
