// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_extended/url_launcher_extended.dart';
import 'package:url_launcher/url_launcher.dart';

class TestUrlLauncherExtended extends UrlLauncherExtended {
  Uri? lastLaunchedUri;

  @override
  Future<bool> canLaunchUrl(Uri url) async {
    return true;
  }

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
}

void main() {
  group('UrlLauncherExtended', () {
    test('tryLaunchMailOrThrow encodes parameters correctly', () async {
      final launcher = TestUrlLauncherExtended();
      final address = 'test@example.com';
      final subject = 'Hello & Welcome';
      final body = 'Line 1\nLine 2';

      await launcher.tryLaunchMailOrThrow(
        address,
        subject: subject,
        body: body,
      );

      final uri = launcher.lastLaunchedUri!;
      expect(uri.scheme, 'mailto');
      expect(uri.path, address);

      // We expect the query parameters to be properly encoded.
      // The Uri class handles decoding when accessing queryParameters.
      expect(uri.queryParameters['subject'], subject);
      expect(uri.queryParameters['body'], body);
    });

    test('tryLaunchMailOrThrow prevents parameter injection', () async {
      final launcher = TestUrlLauncherExtended();
      final address = 'test@example.com';
      // This subject attempts to inject a new body parameter
      final maliciousSubject = 'Hello&body=HACKED';

      await launcher.tryLaunchMailOrThrow(address, subject: maliciousSubject);

      final uri = launcher.lastLaunchedUri!;
      // The subject should be encoded, so '&' becomes '%26'
      expect(uri.queryParameters['subject'], maliciousSubject);
      // There should be no 'body' parameter parsed from the injection
      expect(uri.queryParameters.containsKey('body'), isFalse);
    });
  });
}
