// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone_utils/launch_link.dart';

void main() {
  test('launchURL prevents javascript scheme', () async {
    expect(
      () => launchURL('javascript:alert(1)'),
      throwsA(predicate((e) => e.toString().contains('Insecure scheme'))),
    );
  });

  test('launchURL prevents file scheme', () async {
    expect(
      () => launchURL('file:///etc/passwd'),
      throwsA(predicate((e) => e.toString().contains('Insecure scheme'))),
    );
  });

  test('launchURL allows http scheme', () async {
    // This might fail because launchUrl implementation is missing in test environment,
    // but we verify it passed the security check.
    try {
      await launchURL('http://example.com');
    } catch (e) {
      expect(e.toString(), contains('Could not launchUrl'));
      expect(e.toString(), isNot(contains('Insecure scheme')));
    }
  });

  test('launchURL allows https scheme', () async {
    try {
      await launchURL('https://example.com');
    } catch (e) {
      expect(e.toString(), contains('Could not launchUrl'));
      expect(e.toString(), isNot(contains('Insecure scheme')));
    }
  });

  test('launchURL allows mailto scheme', () async {
    try {
      await launchURL('mailto:test@example.com');
    } catch (e) {
      expect(e.toString(), contains('Could not launchUrl'));
      expect(e.toString(), isNot(contains('Insecure scheme')));
    }
  });
}
