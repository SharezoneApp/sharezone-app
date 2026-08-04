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
      expect(randomIDString(5).length, 5);
      expect(randomIDString(0).length, 0);
    });

    test('generates string with allowed characters', () {
      final validChars = RegExp(r'^[a-zA-Z0-9]+$');
      // Generate a long string to increase probability of hitting all char types if it was broken
      expect(validChars.hasMatch(randomIDString(100)), isTrue);
    });

    test('generates different strings on subsequent calls', () {
      // Very unlikely to collide for length 10
      final s1 = randomIDString(10);
      final s2 = randomIDString(10);
      expect(s1, isNot(equals(s2)));
    });
  });

  group('randomString', () {
    test('generates string of correct length', () {
      expect(randomString(10).length, 10);
    });

    test('generates different strings on subsequent calls', () {
      final s1 = randomString(10);
      final s2 = randomString(10);
      expect(s1, isNot(equals(s2)));
    });
  });
}
