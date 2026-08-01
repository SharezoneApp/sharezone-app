// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/l10n/flutter_app_local_gateway.dart';
import 'package:sharezone/settings/src/subpages/language/language_page.dart';
import 'package:sharezone/util/cache/streaming_key_value_store.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(binding.platformDispatcher.clearLocalesTestValue);

  group(AppLocale, () {
    test('uses the complete preferred locale list', () {
      expect(
        AppLocale.resolveSystemLocale(const [
          Locale('fr', 'FR'),
          Locale('en', 'US'),
        ]),
        const Locale('en'),
      );
    });

    test('falls back to the first supported locale', () {
      expect(
        AppLocale.resolveSystemLocale(const [Locale('fr', 'FR')]),
        const Locale('de'),
      );
    });

    test('serializes explicit language payloads', () {
      expect(AppLocale.en.toMap(), {'isSystem': false, 'languageTag': 'en'});
      expect(AppLocale.de.toMap(), {'isSystem': false, 'languageTag': 'de'});
    });

    test('serializes the effective supported system language', () {
      binding.platformDispatcher.localesTestValue = const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
      ];

      expect(AppLocale.system.toMap(), {'isSystem': true, 'languageTag': 'en'});
    });

    test('deserializes valid and legacy payloads', () {
      expect(
        AppLocale.fromJson({'isSystem': false, 'languageTag': 'de-DE'}),
        AppLocale.de,
      );
      expect(AppLocale.fromJson('EN_us'), AppLocale.en);
    });

    test('defaults malformed payloads to system', () {
      for (final payload in <Object?>[
        null,
        true,
        <Object?>[],
        <String, Object?>{},
        {'isSystem': 'true', 'languageTag': 'en'},
        {'isSystem': false},
        {'isSystem': false, 'languageTag': 42},
        {'isSystem': false, 'languageTag': 'unsupported'},
      ]) {
        expect(
          AppLocale.fromJson(payload),
          AppLocale.system,
          reason: '$payload',
        );
      }
    });
  });

  group(FlutterAppLocaleProviderGateway, () {
    test('defaults a new installation to system', () async {
      final gateway = FlutterAppLocaleProviderGateway(
        keyValueStore: InMemoryStreamingKeyValueStore(),
      );

      expect(await gateway.getLocale().first, AppLocale.system);
    });

    test('persists and emits an explicit language', () async {
      final store = InMemoryStreamingKeyValueStore();
      final gateway = FlutterAppLocaleProviderGateway(keyValueStore: store);

      await gateway.setLocale(AppLocale.en);

      expect(await gateway.getLocale().first, AppLocale.en);
      final storedValue =
          await store.getString('locale', defaultValue: '').first;
      expect(jsonDecode(storedValue), AppLocale.en.toMap());
    });

    test('accepts a legacy plain language tag', () async {
      final store = InMemoryStreamingKeyValueStore();
      await store.setString('locale', 'de-DE');
      final gateway = FlutterAppLocaleProviderGateway(keyValueStore: store);

      expect(await gateway.getLocale().first, AppLocale.de);
    });

    test('defaults invalid JSON to system', () async {
      final store = InMemoryStreamingKeyValueStore();
      await store.setString('locale', '{invalid');
      final gateway = FlutterAppLocaleProviderGateway(keyValueStore: store);

      expect(await gateway.getLocale().first, AppLocale.system);
    });

    test('awaits persistence and reports unsuccessful writes', () async {
      final store = _ControlledStreamingKeyValueStore();
      final gateway = FlutterAppLocaleProviderGateway(keyValueStore: store);

      var completed = false;
      final write = gateway.setLocale(AppLocale.en).whenComplete(() {
        completed = true;
      });
      await Future<void>.delayed(Duration.zero);
      expect(completed, isFalse);

      store.writeResult.complete(false);

      await expectLater(write, throwsStateError);
      expect(completed, isTrue);
    });
  });

  group(AppLocaleProvider, () {
    test('keeps its previous locale when persistence fails', () async {
      final provider = AppLocaleProvider(gateway: _FailingLocaleGateway());
      addTearDown(provider.dispose);
      await Future<void>.delayed(Duration.zero);

      await expectLater(provider.setLocale(AppLocale.en), throwsStateError);

      expect(provider.locale, AppLocale.system);
    });
  });

  testWidgets('system mode reacts to OS locale changes', (tester) async {
    binding.platformDispatcher.localesTestValue = const [Locale('de', 'DE')];
    await tester.pumpWidget(
      MaterialApp(
        locale: AppLocale.system.toFlutterLocale(),
        supportedLocales: SharezoneLocalizations.supportedLocales,
        localizationsDelegates: SharezoneLocalizations.localizationsDelegates,
        home: Builder(builder: (context) => Text(context.l10n.languageTitle)),
      ),
    );
    expect(find.text('Sprache'), findsOneWidget);

    binding.platformDispatcher.localesTestValue = const [Locale('en', 'US')];
    await tester.pump();

    expect(find.text('Language'), findsOneWidget);
  });

  testWidgets('language page surfaces persistence failures', (tester) async {
    final provider = AppLocaleProvider(gateway: _FailingLocaleGateway());
    addTearDown(provider.dispose);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(
          locale: Locale('de'),
          supportedLocales: SharezoneLocalizations.supportedLocales,
          localizationsDelegates: SharezoneLocalizations.localizationsDelegates,
          home: LanguagePage(),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('English'));
    await tester.pump();

    expect(
      find.text('Die Spracheinstellung konnte nicht gespeichert werden.'),
      findsOneWidget,
    );
    expect(provider.locale, AppLocale.system);
  });
}

class _ControlledStreamingKeyValueStore extends InMemoryStreamingKeyValueStore {
  final writeResult = Completer<bool>();

  @override
  Future<bool> setString(String key, String value) => writeResult.future;
}

class _FailingLocaleGateway extends AppLocaleProviderGateway {
  @override
  Stream<AppLocale> getLocale() => Stream.value(AppLocale.system);

  @override
  Future<void> setLocale(AppLocale locale) async {
    throw StateError('Persistence failed.');
  }
}
