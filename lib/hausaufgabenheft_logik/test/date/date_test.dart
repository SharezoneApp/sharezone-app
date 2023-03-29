// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/models/date.dart';
import 'package:test/test.dart';

void main() {
  group('date', () {
    test('Date.fromDateTime', () {
      final dateTime = DateTime(2019, 1, 1, 9, 0);
      final date = Date.fromDateTime(dateTime);
      expect(date, const Date(year: 2019, month: 1, day: 1));
    });

    test('Date.asDateTime - returns the Date as DateTime at midnight ', () {
      const date = Date(year: 2019, month: 1, day: 1);
      final dateAsDateTime = date.asDateTime();
      expect(dateAsDateTime, DateTime(2019, 1, 1, 0, 0, 0, 0, 0));
    });

    test(
        '.addDaysWithNoChecking adds appropiate amount of days, while not checking if the month has been exceeded',
        () {
      expect(const Date(year: 2019, month: 1, day: 1).addDaysWithNoChecking(1),
          const Date(year: 2019, month: 1, day: 2));
      expect(const Date(year: 2019, month: 1, day: 10).addDaysWithNoChecking(-5),
          const Date(year: 2019, month: 1, day: 5));
      // Explicit: DANGER, STUPID ALGORITHM
      expect(const Date(year: 2019, month: 1, day: 30).addDaysWithNoChecking(5),
          const Date(year: 2019, month: 1, day: 35));
    });
    test('.addDays adds day regarding the month length', () {
      expect(const Date(year: 2019, month: 11, day: 30).addDays(1),
          const Date(year: 2019, month: 12, day: 1)); // has 30 days
    });
    test('.addDays subtracts if given a negative number', () {
      expect(const Date(year: 2019, month: 11, day: 30).addDays(-1),
          const Date(year: 2019, month: 11, day: 29));
    });
    test('.addDays returns the same date if given 0', () {
      var date = const Date(year: 2019, month: 11, day: 30);
      expect(date.addDays(0), date);
    });

    test('Date.now', () {
      final now = Date.now();
      var nowDateTime = DateTime.now();
      expect(now.year, nowDateTime.year);
      expect(now.month, nowDateTime.month);
      expect(now.day, nowDateTime.day);
    });
    group('comparison', () {
      const d28_01_2017 = Date(day: 28, month: 1, year: 2017);
      const d28_01_2018 = Date(day: 28, month: 1, year: 2018);
      const d28_00_2018 = Date(day: 28, month: 0, year: 2018);
      const d29_01_2018 = Date(day: 29, month: 1, year: 2018);
      test('if date is one year before other', () {
        expect(d28_01_2017 < d28_01_2018, true);
        expect(d28_01_2018 > d28_01_2017, true);
      });
      test('if date is one month before other', () {
        expect(d28_00_2018 < d28_01_2018, true);
        expect(d28_01_2018 > d28_00_2018, true);
      });
      test('if date is one day before other', () {
        expect(d28_01_2018 > d29_01_2018, false);
        expect(d28_01_2018 < d29_01_2018, true);
        expect(d29_01_2018 > d28_01_2018, true);
        expect(d29_01_2018 < d28_01_2018, false);
      });
      test('if date is the same', () {
        expect(d28_00_2018 == d28_00_2018, true);
        expect(d28_00_2018 == d28_01_2018, false);
      });
    });
  });
}
