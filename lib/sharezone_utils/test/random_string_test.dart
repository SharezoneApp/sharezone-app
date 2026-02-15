// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone_utils/random_string.dart';

void main() {
  group('randomIDString', () {
    test('returns string of correct length', () {
      expect(randomIDString(10).length, 10);
      expect(randomIDString(0).length, 0);
      expect(randomIDString(100).length, 100);
    });

    test('returns string containing only allowed characters', () {
      const allowedChars =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      final result = randomIDString(1000);
      for (var i = 0; i < result.length; i++) {
        expect(
          allowedChars.contains(result[i]),
          isTrue,
          reason: 'Character ${result[i]} not allowed',
        );
      }
    });

    test('returns different strings on subsequent calls', () {
      expect(randomIDString(10), isNot(equals(randomIDString(10))));
    });
  });

  group('randomString', () {
    test('returns string of correct length', () {
      expect(randomString(10).length, 10);
      expect(randomString(0).length, 0);
      expect(randomString(100).length, 100);
    });

    test('returns string with characters in expected range', () {
      // Range used in original implementation: nextInt(33) + 89 => [89, 121]
      // 89 is 'Y', 121 is 'y'.
      // Wait, nextInt(33) is 0..32.
      // 89 + 0 = 89 ('Y')
      // 89 + 32 = 121 ('y')
      // Original code:
      // rand.nextInt(33) + 89

      final result = randomString(1000);
      for (var i = 0; i < result.length; i++) {
        final code = result.codeUnitAt(i);
        expect(code, greaterThanOrEqualTo(89));
        expect(code, lessThan(89 + 33));
      }
    });

    test('returns different strings on subsequent calls', () {
      expect(randomString(10), isNot(equals(randomString(10))));
    });
  });
}
