// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
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
  Uri? launchedUri;

  @override
  Future<bool> canLaunchUrl(Uri url) async => true;

  @override
  Future<bool> launchUrl(
    Uri url, {
    LaunchMode mode = LaunchMode.platformDefault,
    WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
    String? webOnlyWindowName,
  }) async {
    launchedUri = url;
    return true;
  }
}

void main() {
  group('UrlLauncherExtended', () {
    late TestUrlLauncherExtended urlLauncherExtended;

    setUp(() {
      urlLauncherExtended = TestUrlLauncherExtended();
    });

    test('tryLaunchMailOrThrow encodes subject and body correctly', () async {
      const address = 'test@sharezone.net';
      const subject = 'Hello & World';
      const body = 'This is a body with ? and &';

      await urlLauncherExtended.tryLaunchMailOrThrow(
        address,
        subject: subject,
        body: body,
      );

      final launchedUri = urlLauncherExtended.launchedUri;
      expect(launchedUri, isNotNull);
      expect(launchedUri!.scheme, 'mailto');
      expect(launchedUri.path, address);

      // We expect the query parameters to be properly encoded.
      // The queryParameters map in Uri automatically decodes them, so checking map values is a good way to verify they were encoded in the URI string if we trust Uri parsing.
      // But to be sure about the raw string, we can check .toString()

      // Expected behavior: Special characters should be percent-encoded in the string representation.
      // but Uri.parse() used in the implementation might "fix" some things or not.
      // The issue is that the *input* to Uri.parse in the current implementation is NOT encoded.
      // So if we pass "Hello & World", the constructed string is "...?subject=Hello & World...".
      // Uri.parse might read "Hello " as subject and create a new key " World".

      // If the fix is applied, we expect full correctness.

      expect(launchedUri.queryParameters['subject'], subject);
      expect(launchedUri.queryParameters['body'], body);

      // Also check that there are no extra keys (which would happen if & was interpreted as separator)
      expect(launchedUri.queryParameters.keys.length, 2);
    });

    test('tryLaunchMailOrThrow handles simple email', () async {
      const address = 'test@sharezone.net';
      await urlLauncherExtended.tryLaunchMailOrThrow(address);

      final launchedUri = urlLauncherExtended.launchedUri;
      expect(launchedUri, isNotNull);
      expect(launchedUri!.scheme, 'mailto');
      expect(launchedUri.path, address);
      expect(launchedUri.queryParameters, isEmpty);
    });
  });
}
