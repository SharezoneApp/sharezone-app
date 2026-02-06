// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/link.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../flutter_test_config.dart';

void main() {
  group('launchSafeLink dialog', () {
    late UrlLauncherPlatform originalLauncher;
    late _GoldenFakeUrlLauncher launcher;

    setUp(() {
      originalLauncher = UrlLauncherPlatform.instance;
      launcher = _GoldenFakeUrlLauncher();
      UrlLauncherPlatform.instance = launcher;
    });

    tearDown(() {
      UrlLauncherPlatform.instance = originalLauncher;
    });

    testGoldens('renders mismatch dialog in light mode', (tester) async {
      final context = await tester.pumpScene(
        theme: getLightTheme(fontFamily: roboto),
      );

      if (!context.mounted) {
        fail('Context was not mounted');
      }

      launchMarkdownLinkWithWarning(
        text: 'https://google.com',
        href: 'https://evil-google.com',
        context: context,
        keyValueStore: InMemoryKeyValueStore(),
      );

      await tester.pump();

      await screenMatchesGolden(tester, 'launch_safe_link_dialog_light');
    });

    testGoldens('renders mismatch dialog in dark mode', (tester) async {
      final context = await tester.pumpScene(
        theme: getDarkTheme(fontFamily: roboto),
      );

      if (!context.mounted) {
        fail('Context was not mounted');
      }

      launchMarkdownLinkWithWarning(
        text: 'https://google.com',
        href: 'https://evil-google.com',
        context: context,
        keyValueStore: InMemoryKeyValueStore(),
      );

      await tester.pump();

      await screenMatchesGolden(tester, 'launch_safe_link_dialog_dark');
    });
  });
}

extension on WidgetTester {
  Future<BuildContext> pumpScene({required ThemeData theme}) async {
    late BuildContext context;
    await pumpWidgetBuilder(
      Scaffold(
        body: Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
      wrapper: materialAppWrapper(
        theme: theme,
        localeOverrides: defaultLocales,
        localizations: SharezoneLocalizations.localizationsDelegates,
      ),
    );
    return context;
  }
}

class _GoldenFakeUrlLauncher extends UrlLauncherPlatform {
  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    String? webOnlyWindowName,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    return true;
  }
}
