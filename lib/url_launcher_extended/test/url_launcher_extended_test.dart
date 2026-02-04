// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_extended/src/url_launcher_extended.dart';
import 'package:url_launcher/url_launcher.dart';

class TestUrlLauncherExtended extends UrlLauncherExtended {
  Uri? lastLaunchedUri;

  @override
  Future<bool> launchUrl(
    Uri url, {
    LaunchMode mode = LaunchMode.platformDefault,
    WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
    String? webOnlyWindowName,
  }) async {
    lastLaunchedUri = url;
    return true;
  }

  @override
  Future<bool> canLaunchUrl(Uri url) async {
    return true;
  }
}

void main() {
  test('Security: prevents parameter injection in mailto links', () async {
    final launcher = TestUrlLauncherExtended();

    // Malicious subject attempting to inject a CC header
    final subject = 'Hello&cc=hacker@example.com';

    await launcher.tryLaunchMailOrThrow(
      'user@example.com',
      subject: subject,
      body: 'Body',
    );

    final uri = launcher.lastLaunchedUri!;

    print('Generated URI: $uri');
    print('Query Parameters: ${uri.queryParameters}');

    // The injected parameters should NOT be parsed as separate query keys.
    expect(
      uri.queryParameters.containsKey('cc'),
      isFalse,
      reason: 'CC parameter was injected',
    );

    // The subject should contain the full string (properly encoded in the URI string)
    expect(uri.queryParameters['subject'], equals(subject));

    // Verify string representation contains encoded characters
    // & should be %26, = should be %3D
    expect(
      uri.toString(),
      contains('subject=Hello%26cc%3Dhacker%40example.com'),
    );
  });

  test('Normal usage works correctly', () async {
    final launcher = TestUrlLauncherExtended();

    await launcher.tryLaunchMailOrThrow(
      'user@example.com',
      subject: 'Hello World',
      body: 'This is a body',
    );

    final uri = launcher.lastLaunchedUri!;

    expect(uri.scheme, equals('mailto'));
    expect(uri.path, equals('user@example.com'));
    expect(uri.queryParameters['subject'], equals('Hello World'));
    expect(uri.queryParameters['body'], equals('This is a body'));
  });
}
