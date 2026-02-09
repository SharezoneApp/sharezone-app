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
  group('randomString', () {
    test('returns string of correct length', () {
      expect(randomString(10).length, 10);
      expect(randomString(0).length, 0);
      expect(randomString(100).length, 100);
    });

    test('returns different strings on subsequent calls', () {
      final str1 = randomString(10);
      final str2 = randomString(10);
      expect(str1, isNot(equals(str2)));
    });

    test('returns characters within expected range (89 to 121)', () {
      // 89 to 89 + 33 = 122 (exclusive) -> 89 to 121
      // 'Y' (89) to 'y' (121)
      final str = randomString(100);
      for (final charCode in str.codeUnits) {
        expect(charCode, greaterThanOrEqualTo(89));
        expect(charCode, lessThan(122));
      }
    });
  });

  group('randomIDString', () {
    test('returns string of correct length', () {
      expect(randomIDString(10).length, 10);
      expect(randomIDString(0).length, 0);
      expect(randomIDString(100).length, 100);
    });

    test('returns different strings on subsequent calls', () {
      final str1 = randomIDString(10);
      final str2 = randomIDString(10);
      expect(str1, isNot(equals(str2)));
    });

    test('returns only alphanumeric characters', () {
      final str = randomIDString(100);
      final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
      expect(alphanumeric.hasMatch(str), isTrue);
    });
  });
}
