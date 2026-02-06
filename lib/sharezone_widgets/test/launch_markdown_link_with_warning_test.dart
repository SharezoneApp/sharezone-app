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
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:sharezone_widgets/src/launch_markdown_link_with_warning.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/link.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

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

    await launchMarkdownLinkWithWarning(
      text: 'https://sharezone.net',
      href: 'https://sharezone.net',
      context: context,
      keyValueStore: store,
    );

    expect(fakeLauncher.launchUrlCallCount, 1);
    expect(find.byType(AlertDialog), findsNothing);
    expect(store.containsKey(trustedDomainsStoreKey), isFalse);
  });

  testWidgets('shows confirmation dialog when text differs', (tester) async {
    final store = InMemoryKeyValueStore();
    final context = await _pumpTestHost(tester);

    final launchFuture = launchMarkdownLinkWithWarning(
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
    expect(store.containsKey(trustedDomainsStoreKey), isFalse);
  });

  testWidgets('stores trusted domain when user opts in', (tester) async {
    final store = InMemoryKeyValueStore();
    final context = await _pumpTestHost(tester);

    final launchFuture = launchMarkdownLinkWithWarning(
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
      store.getStringList(trustedDomainsStoreKey),
      contains('evil.google.com'),
    );

    fakeLauncher.launchUrlCallCount = 0;

    await launchMarkdownLinkWithWarning(
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

    await launchMarkdownLinkWithWarning(
      text: 'https://sharezone.net',
      href: 'https://sharezone.net',
      context: context,
      keyValueStore: store,
    );

    await tester.pump();

    expect(find.text('Der Link konnte nicht geöffnet werden!'), findsOneWidget);
  });

  testWidgets('normalizes bare domain without scheme when text matches href', (
    tester,
  ) async {
    final store = InMemoryKeyValueStore();
    final context = await _pumpTestHost(tester);

    await launchMarkdownLinkWithWarning(
      text: 'google.com',
      href: 'google.com',
      context: context,
      keyValueStore: store,
    );

    expect(find.byType(AlertDialog), findsNothing);
    expect(fakeLauncher.launchUrlCallCount, 1);
    expect(fakeLauncher.lastUrl, 'https://google.com');
  });

  testWidgets(
    'shows dialog and launches normalized bare domain when text differs',
    (tester) async {
      final store = InMemoryKeyValueStore();
      final context = await _pumpTestHost(tester);

      final launchFuture = launchMarkdownLinkWithWarning(
        text: 'https://google.com',
        href: 'google.com',
        context: context,
        keyValueStore: store,
      );

      await tester.pump();

      expect(find.text('Link überprüfen'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Link öffnen'));
      await tester.pumpAndSettle();
      await launchFuture;

      expect(fakeLauncher.launchUrlCallCount, greaterThan(0));
      expect(fakeLauncher.lastUrl, 'https://google.com');
    },
  );

  group('toLaunchableUri()', () {
    test('normalizes plain domain', () {
      expect(toLaunchableUri('google.com')!.toString(), 'https://google.com');
      expect(
        toLaunchableUri('www.google.com')!.toString(),
        'https://www.google.com',
      );
      expect(
        toLaunchableUri('sub.domain.co.uk')!.toString(),
        'https://sub.domain.co.uk',
      );
    });

    test('normalizes domain with path, query, and fragment', () {
      expect(
        toLaunchableUri('example.io/path')!.toString(),
        'https://example.io/path',
      );
      expect(
        toLaunchableUri('example.de/search?q=test')!.toString(),
        'https://example.de/search?q=test',
      );
      expect(
        toLaunchableUri('example.dev/#frag')!.toString(),
        'https://example.dev/#frag',
      );
    });

    test('trims whitespace before normalization', () {
      expect(
        toLaunchableUri('  example.com  ')!.toString(),
        'https://example.com',
      );
    });

    test('keeps URIs with existing scheme unchanged', () {
      expect(
        toLaunchableUri('https://example.com')!.toString(),
        'https://example.com',
      );
      expect(
        toLaunchableUri('http://example.com')!.toString(),
        'http://example.com',
      );
      expect(
        toLaunchableUri('mailto:test@example.com')!.toString(),
        'mailto:test@example.com',
      );
      expect(toLaunchableUri('tel:+4912345')!.toString(), 'tel:+4912345');
      expect(
        toLaunchableUri('ftp://example.com')!.toString(),
        'ftp://example.com',
      );
    });

    test('does not normalize non-domain inputs without scheme', () {
      final localhost = toLaunchableUri('localhost');
      expect(localhost, isNotNull);
      expect(localhost!.hasScheme, isFalse);
      expect(localhost.hasAuthority, isFalse);

      final ip = toLaunchableUri('127.0.0.1');
      expect(ip, isNotNull);
      expect(ip!.hasScheme, isFalse);
      expect(ip.hasAuthority, isFalse);

      expect(toLaunchableUri('example'), isNotNull);
      expect(toLaunchableUri('example.c')!.hasScheme, isFalse);
    });

    test('supports hyphens but rejects underscores in domains', () {
      expect(toLaunchableUri('my-site.com')!.toString(), 'https://my-site.com');

      final underscore = toLaunchableUri('my_site.com');
      expect(underscore, isNotNull);
      expect(underscore!.hasScheme, isFalse);
    });

    test('normalizes domains with explicit ports', () {
      final withPort = toLaunchableUri('example.com:8080');
      expect(withPort, isNotNull);
      expect(withPort!.toString(), 'https://example.com:8080');
    });

    test('does not treat emails as domains', () {
      final emailish = toLaunchableUri('user@example.com');
      expect(emailish, isNotNull);
      expect(emailish!.hasScheme, isFalse);
    });

    test('handles uppercase and extra whitespace (lowercases host)', () {
      expect(
        toLaunchableUri('  EXAMPLE.COM  ')!.toString(),
        'https://example.com',
      );
    });

    test('does not normalize trailing dot or protocol-relative inputs', () {
      final trailingDot = toLaunchableUri('example.com.');
      expect(trailingDot, isNotNull);
      expect(trailingDot!.hasScheme, isFalse);

      final protocolRelative = toLaunchableUri('// example.com');
      expect(protocolRelative, isNotNull);
      expect(protocolRelative!.hasScheme, isFalse);
      expect(protocolRelative.hasAuthority, isTrue);
    });

    test('does not normalize IPv6 literals (returns null)', () {
      final ipv6 = toLaunchableUri('[::1]');
      expect(ipv6, isNull);
    });

    test('supports punycode domains', () {
      expect(toLaunchableUri('xn--fsq.com')!.toString(), 'https://xn--fsq.com');
    });
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
      localizationsDelegates: SharezoneLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('de')],
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
