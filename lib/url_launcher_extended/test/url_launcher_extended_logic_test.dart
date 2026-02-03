// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_extended/url_launcher_extended.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class TestUrlLauncherExtended extends UrlLauncherExtended {
  Uri? capturedUri;

  @override
  Future<bool> canLaunchUrl(Uri url) async => true;

  @override
  Future<bool> launchUrl(
    Uri url, {
    launcher.LaunchMode mode = launcher.LaunchMode.platformDefault,
    launcher.WebViewConfiguration webViewConfiguration =
        const launcher.WebViewConfiguration(),
    String? webOnlyWindowName,
  }) async {
    capturedUri = url;
    return true;
  }
}

void main() {
  group('UrlLauncherExtended', () {
    late TestUrlLauncherExtended urlLauncher;

    setUp(() {
      urlLauncher = TestUrlLauncherExtended();
    });

    test('tryLaunchMailOrThrow handles parameter injection', () async {
      const address = "support@example.com";
      const subject = "Hello & World";
      const body = "Content & body=injection";

      await urlLauncher.tryLaunchMailOrThrow(
        address,
        subject: subject,
        body: body,
      );

      final uri = urlLauncher.capturedUri!;
      expect(uri.scheme, 'mailto');
      expect(uri.path, address);

      // Check that parameters are correctly encoded and not injected
      expect(uri.queryParameters['subject'], subject);
      expect(uri.queryParameters['body'], body);

      // The raw query should contain encoded values
      // & should be %26
      expect(uri.query.contains('Hello+%26+World') || uri.query.contains('Hello%20%26%20World'), true);
    });
  });
}
