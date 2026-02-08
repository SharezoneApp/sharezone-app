// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
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
    test('generates string of correct length', () {
      expect(randomIDString(10).length, 10);
      expect(randomIDString(0).length, 0);
      expect(randomIDString(100).length, 100);
    });

    test('generates string with allowed characters', () {
      const allowedChars =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      final result = randomIDString(100);
      for (final char in result.runes) {
        expect(allowedChars.contains(String.fromCharCode(char)), isTrue);
      }
    });

    test('generates different strings', () {
      final s1 = randomIDString(20);
      final s2 = randomIDString(20);
      expect(s1, isNot(equals(s2)));
    });
  });

  group('randomString', () {
    test('generates string of correct length', () {
      expect(randomString(10).length, 10);
      expect(randomString(0).length, 0);
      expect(randomString(100).length, 100);
    });

    test('generates different strings', () {
      final s1 = randomString(20);
      final s2 = randomString(20);
      expect(s1, isNot(equals(s2)));
    });
  });
}
