// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/link.dart';

void main() {
  late UrlLauncherPlatform originalLauncher;
  late _FakeUrlLauncher fakeLauncher;

  setUp(() {
    originalLauncher = UrlLauncherPlatform.instance;
    fakeLauncher = _FakeUrlLauncher();
    UrlLauncherPlatform.instance = fakeLauncher;
  });

  tearDown(() {
    UrlLauncherPlatform.instance = originalLauncher;
  });

  testWidgets('launches immediately when text matches href', (tester) async {
    final store = InMemoryKeyValueStore();
    final context = await _pumpTestHost(tester);

    await launchSafeLink(
      text: 'https://sharezone.net',
      href: 'https://sharezone.net',
      context: context,
      keyValueStore: store,
    );

    expect(fakeLauncher.launchUrlCallCount, 1);
    expect(find.byType(AlertDialog), findsNothing);
    expect(
      store.containsKey('sharezone_widgets.markdown.trusted_link_domains'),
      isFalse,
    );
  });

  testWidgets('shows confirmation dialog when text differs', (tester) async {
    final store = InMemoryKeyValueStore();
    final context = await _pumpTestHost(tester);

    final launchFuture = launchSafeLink(
      text: 'https://google.com',
      href: 'https://evil-google.com',
      context: context,
      keyValueStore: store,
    );

    await tester.pump();

    expect(find.text('Link überprüfen'), findsOneWidget);
    expect(find.text('Tatsächliche Adresse'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Link öffnen'));
    await tester.pumpAndSettle();
    await launchFuture;

    expect(fakeLauncher.launchUrlCallCount, 1);
    expect(
      store.containsKey('sharezone_widgets.markdown.trusted_link_domains'),
      isFalse,
    );
  });

  testWidgets('stores trusted domain when user opts in', (tester) async {
    final store = InMemoryKeyValueStore();
    final context = await _pumpTestHost(tester);

    final launchFuture = launchSafeLink(
      text: 'https://google.com',
      href: 'https://evil.google.com',
      context: context,
      keyValueStore: store,
    );

    await tester.pump();
    expect(find.byType(CheckboxListTile), findsOneWidget);

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Link öffnen'));
    await tester.pumpAndSettle();
    await launchFuture;

    expect(
      store.getStringList('sharezone_widgets.markdown.trusted_link_domains'),
      contains('evil.google.com'),
    );

    fakeLauncher.launchUrlCallCount = 0;

    await launchSafeLink(
      text: 'Hier klicken',
      href: 'https://evil.google.com',
      context: context,
      keyValueStore: store,
    );

    await tester.pump();

    expect(fakeLauncher.launchUrlCallCount, 1);
    expect(find.text('Link überprüfen'), findsNothing);
  });

  testWidgets('shows snackbar when launch fails', (tester) async {
    final store = InMemoryKeyValueStore();
    final context = await _pumpTestHost(tester);

    fakeLauncher.shouldSucceed = false;

    await launchSafeLink(
      text: 'https://sharezone.net',
      href: 'https://sharezone.net',
      context: context,
      keyValueStore: store,
    );

    await tester.pump();

    expect(find.text('Der Link konnte nicht geöffnet werden!'), findsOneWidget);
  });
}

class _FakeUrlLauncher extends UrlLauncherPlatform {
  int launchUrlCallCount = 0;
  bool shouldSucceed = true;
  String? lastUrl;

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
    launchUrlCallCount++;
    lastUrl = url;
    return shouldSucceed;
  }
}

Future<BuildContext> _pumpTestHost(WidgetTester tester) async {
  late BuildContext capturedContext;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );

  return capturedContext;
}
