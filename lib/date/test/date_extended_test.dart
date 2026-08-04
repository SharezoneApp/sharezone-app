// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/date.dart';
import 'package:test/test.dart';

void main() {
  group('Date', () {
    test('parse and parseOrNull', () {
      expect(Date.parse('2023-10-25').toString(), '2023-10-25');
      expect(Date('2023-10-25').toString(), '2023-10-25');

      expect(Date.parseOrNull('2023-10-25'), Date('2023-10-25'));
      expect(Date.parseOrNull(null), null);

      // Invalid dates might throw or return unexpected results depending on DateTime implementation
      // DateTime.parse throws on invalid format
      final invalid = Date.parse('invalid');
      expect(() => invalid.toDateTime, throwsFormatException);
    });

    test('equality and hashCode', () {
      final d1 = Date('2023-10-25');
      final d2 = Date('2023-10-25');
      final d3 = Date('2023-10-26');

      expect(d1, equals(d2));
      expect(d1, isNot(equals(d3)));
      expect(d1.hashCode, equals(d2.hashCode));
      expect(d1.hashCode, isNot(equals(d3.hashCode)));
    });

    test('isAfter and isBefore', () {
      final d1 = Date('2023-10-25');
      final d2 = Date('2023-10-26');

      expect(d1.isBefore(d2), isTrue);
      expect(d2.isAfter(d1), isTrue);
      expect(d1.isAfter(d2), isFalse);
      expect(d2.isBefore(d1), isFalse);
      expect(d1.isBefore(d1), isFalse);
      expect(d1.isAfter(d1), isFalse);
    });

    test('isSameDay', () {
      final d1 = Date('2023-10-25');
      final d2 = Date('2023-10-25');
      final d3 = Date('2023-10-26');

      expect(d1.isSameDay(d2), isTrue);
      expect(d1.isSameDay(d3), isFalse);
    });

    test('isInsideDateRange', () {
      final start = Date('2023-10-20');
      final end = Date('2023-10-30');

      final inside = Date('2023-10-25');
      final outsideBefore = Date('2023-10-19');
      final outsideAfter = Date('2023-10-31');

      expect(inside.isInsideDateRange(start, end), isTrue);
      expect(outsideBefore.isInsideDateRange(start, end), isFalse);
      expect(outsideAfter.isInsideDateRange(start, end), isFalse);

      // Boundary checks
      expect(start.isInsideDateRange(start, end), isTrue);
      expect(end.isInsideDateRange(start, end), isTrue);
    });

    group('addDays', () {
      test('simple addition', () {
        final d = Date('2023-10-25');
        expect(d.addDays(1), Date('2023-10-26'));
        expect(d.addDays(5), Date('2023-10-30'));
      });

      test('month boundary', () {
        final d = Date('2023-10-31');
        expect(d.addDays(1), Date('2023-11-01'));
      });

      test('year boundary', () {
        final d = Date('2023-12-31');
        expect(d.addDays(1), Date('2024-01-01'));
      });

      test('leap year', () {
        final d = Date('2024-02-28');
        expect(d.addDays(1), Date('2024-02-29'));
        expect(d.addDays(2), Date('2024-03-01'));

        final nonLeap = Date('2023-02-28');
        expect(nonLeap.addDays(1), Date('2023-03-01'));
      });

      test('negative days', () {
        final d = Date('2023-10-25');
        expect(d.addDays(-1), Date('2023-10-24'));
        expect(d.addDays(-25), Date('2023-09-30'));
      });

      test('DST Spring Forward (March)', () {
        // Germany 2023: March 26 (Sunday) 2:00 -> 3:00
        final d = Date('2023-03-25');
        expect(d.addDays(1), Date('2023-03-26'));
        expect(d.addDays(2), Date('2023-03-27'));
      });

      test('DST Fall Back (October)', () {
        // Germany 2023: Oct 29 (Sunday) 3:00 -> 2:00
        final d = Date('2023-10-28');
        expect(d.addDays(1), Date('2023-10-29'));
        expect(d.addDays(2), Date('2023-10-30'));
      });

      test('Large range crossing multiple DST', () {
        final d = Date('2023-01-01');
        expect(d.addDays(365), Date('2024-01-01')); // 2023 is not leap year
      });
    });

    group('getWeekNumber', () {
      test('normal week', () {
        // 2023-10-25 is Wednesday, Week 43
        expect(getWeekNumber(DateTime(2023, 10, 25)), 43);
      });

      test('start of year', () {
        // 2023-01-04 (Wednesday). Week 1 (contains Jan 5).
        // dayOfYear=4. weekday=3.
        // (4 - 3 + 10) / 7 = 11 / 7 = 1.57 -> 1. Correct.
        expect(getWeekNumber(DateTime(2023, 1, 4)), 1);
      });
    });
  });
}
