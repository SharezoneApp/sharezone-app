// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hausaufgabenheft_logik/src/shared/models/date.dart';

void main() {
  group('Date Tests', () {
    test('Date.now() uses clock', () {
      withClock(Clock.fixed(DateTime(2023, 10, 15, 12, 30)), () {
        final date = Date.now();
        expect(date.year, 2023);
        expect(date.month, 10);
        expect(date.day, 15);
      });
    });

    test('addDays correctly wraps months and years', () {
      const date = Date(day: 31, month: 12, year: 2023);
      final nextDay = date.addDays(1);

      expect(nextDay.day, 1);
      expect(nextDay.month, 1);
      expect(nextDay.year, 2024);
    });

    test('compareTo orders dates correctly', () {
      const earlier = Date(day: 14, month: 10, year: 2023);
      const laterDay = Date(day: 15, month: 10, year: 2023);
      const laterMonth = Date(day: 14, month: 11, year: 2023);
      const laterYear = Date(day: 14, month: 10, year: 2024);

      expect(earlier.compareTo(laterDay), lessThan(0));
      expect(earlier.compareTo(laterMonth), lessThan(0));
      expect(earlier.compareTo(laterYear), lessThan(0));

      expect(laterDay.compareTo(earlier), greaterThan(0));
      expect(earlier.compareTo(earlier), equals(0));
    });

    test('Operators > and < work correctly', () {
      const earlier = Date(day: 1, month: 1, year: 2023);
      const later = Date(day: 2, month: 1, year: 2023);

      expect(later > earlier, isTrue);
      expect(earlier < later, isTrue);
      expect(earlier > later, isFalse);
      expect(later < earlier, isFalse);
    });
  });
}
