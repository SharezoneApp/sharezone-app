// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/date.dart';
import 'package:date/weekday.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/timetable/src/logic/timetable_date_helper.dart';
import 'package:user/user.dart';

void main() {
  group(TimetableDateHelper.shouldOpenUpcomingWeek, () {
    test(
      'opens upcoming week after last enabled weekday when feature is enabled',
      () {
        final today = Date.parse('2024-08-10'); // Saturday
        final result = TimetableDateHelper.shouldOpenUpcomingWeek(
          today: today,
          enabledWeekDays: EnabledWeekDays.standard,
          isFeatureEnabled: true,
          eventDatesInCurrentWeek: <Date>[],
        );

        expect(result, isTrue);
      },
    );

    test('does not open upcoming week when feature is disabled', () {
      final today = Date.parse('2024-08-10'); // Saturday
      final result = TimetableDateHelper.shouldOpenUpcomingWeek(
        today: today,
        enabledWeekDays: EnabledWeekDays.standard,
        isFeatureEnabled: false,
        eventDatesInCurrentWeek: <Date>[],
      );

      expect(result, isFalse);
    });

    test('does not open upcoming week when today is an enabled weekday', () {
      final today = Date.parse('2024-08-10'); // Saturday
      final enabledWeekDays = EnabledWeekDays.fromEnabledWeekDaysList([
        WeekDay.monday,
        WeekDay.tuesday,
        WeekDay.wednesday,
        WeekDay.thursday,
        WeekDay.friday,
        WeekDay.saturday,
      ]);
      final result = TimetableDateHelper.shouldOpenUpcomingWeek(
        today: today,
        enabledWeekDays: enabledWeekDays,
        isFeatureEnabled: true,
        eventDatesInCurrentWeek: <Date>[],
      );

      expect(result, isFalse);
    });

    test('does not open upcoming week when there is an upcoming event', () {
      final today = Date.parse('2024-08-10'); // Saturday
      final result = TimetableDateHelper.shouldOpenUpcomingWeek(
        today: today,
        enabledWeekDays: EnabledWeekDays.standard,
        isFeatureEnabled: true,
        eventDatesInCurrentWeek: [Date.parse('2024-08-10')],
      );

      expect(result, isFalse);
    });
  });
}
