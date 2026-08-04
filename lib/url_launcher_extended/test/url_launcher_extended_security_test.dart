// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_extended/src/url_launcher_extended.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/link.dart';

class MockUrlLauncher extends MockPlatformInterfaceMixin implements UrlLauncherPlatform {
  String? launchUrlCalledWith;
  String? canLaunchUrlCalledWith;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchUrlCalledWith = url;
    return true;
  }

  @override
  Future<bool> canLaunch(String url) async {
    canLaunchUrlCalledWith = url;
    return true;
  }

  @override
  Future<void> closeWebView() async {}

  @override
  Future<bool> supportsMode(PreferredLaunchMode mode) async => true;

  @override
  Future<bool> supportsCloseForMode(PreferredLaunchMode mode) async => true;

  // Deprecated member, but required to be implemented
  @override
  Future<bool> launch(String url, {required bool useSafariVC, required bool useWebView, required bool enableJavaScript, required bool enableDomStorage, required bool universalLinksOnly, required Map<String, String> headers, String? webOnlyWindowName}) async {
    launchUrlCalledWith = url;
    return true;
  }

  @override
  LinkDelegate? get linkDelegate => null;
}

void main() {
  test('Security: launchUrl throws ArgumentError for disallowed schemes', () async {
    final mock = MockUrlLauncher();
    UrlLauncherPlatform.instance = mock;

    final launcher = UrlLauncherExtended();
    final dangerousUrl = Uri.parse('javascript:alert("XSS")');

    // Expect ArgumentError when launching a disallowed scheme
    expect(
      () => launcher.launchUrl(dangerousUrl),
      throwsA(isA<ArgumentError>()),
    );

    // Ensure platform method was NOT called (if exception thrown before)
    expect(mock.launchUrlCalledWith, isNull);
  });

  test('Security: canLaunchUrl returns false for disallowed schemes', () async {
    final mock = MockUrlLauncher();
    UrlLauncherPlatform.instance = mock;

    final launcher = UrlLauncherExtended();
    final dangerousUrl = Uri.parse('javascript:alert("XSS")');

    // Expect false when checking a disallowed scheme
    final canLaunch = await launcher.canLaunchUrl(dangerousUrl);
    expect(canLaunch, isFalse);

    // Ensure platform method was NOT called
    expect(mock.canLaunchUrlCalledWith, isNull);
  });

  test('Security: canLaunchUrl returns true (or platform result) for allowed schemes', () async {
    final mock = MockUrlLauncher();
    UrlLauncherPlatform.instance = mock;

    final launcher = UrlLauncherExtended();
    final allowedUrl = Uri.parse('https://example.com');

    // Expect true (mock returns true)
    final canLaunch = await launcher.canLaunchUrl(allowedUrl);
    expect(canLaunch, isTrue);

    // Ensure platform method WAS called
    expect(mock.canLaunchUrlCalledWith, 'https://example.com');
  });
}
