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
  group('randomString', () {
    test('generates string of correct length', () {
      expect(randomString(10).length, 10);
      expect(randomString(0).length, 0);
      expect(randomString(100).length, 100);
    });

    test('generates characters in expected range', () {
      final str = randomString(1000);
      for (final code in str.codeUnits) {
        expect(code, greaterThanOrEqualTo(89));
        // nextInt(33) returns 0..32. 89 + 32 = 121.
        // So max value is 121.
        expect(code, lessThanOrEqualTo(121));
      }
    });
  });

  group('randomIDString', () {
    test('generates string of correct length', () {
      expect(randomIDString(10).length, 10);
      expect(randomIDString(0).length, 0);
      expect(randomIDString(100).length, 100);
    });

    test('generates alphanumeric characters', () {
      final str = randomIDString(1000);
      const validChars =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      for (int i = 0; i < str.length; i++) {
        expect(
          validChars.contains(str[i]),
          isTrue,
          reason: 'Character ${str[i]} not in valid set',
        );
      }
    });
  });
}
