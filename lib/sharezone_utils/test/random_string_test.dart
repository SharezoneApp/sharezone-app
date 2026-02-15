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
    test('returns string of correct length', () {
      expect(randomString(10).length, 10);
      expect(randomString(0).length, 0);
      expect(randomString(100).length, 100);
    });

    test('returns different strings on subsequent calls', () {
      expect(randomString(10), isNot(randomString(10)));
    });
  });

  group('randomIDString', () {
    test('returns string of correct length', () {
      expect(randomIDString(10).length, 10);
      expect(randomIDString(0).length, 0);
      expect(randomIDString(100).length, 100);
    });

    test('returns string with allowed characters only', () {
      const allowed =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      final result = randomIDString(100);
      for (var i = 0; i < result.length; i++) {
        expect(allowed.contains(result[i]), isTrue);
      }
    });

    test('returns different strings on subsequent calls', () {
      expect(randomIDString(10), isNot(randomIDString(10)));
    });
  });
}
