// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:date/date.dart';
import 'package:user/user.dart';

class TimetableDateHelper {
  static Date dateBeginThisWeek({Date? today}) {
    final currentDate = today ?? Date.today();
    Date startOfThisWeek = currentDate.addDays(-(currentDate.weekDay - 1));
    return startOfThisWeek;
  }

  static Date dateAddDays(Date date, int days) {
    return date.addDays(days);
  }

  static Date dateAddWeeks(Date date, int weeks) {
    return dateAddDays(date, weeks * 7);
  }

  static bool shouldOpenUpcomingWeek({
    required Date today,
    required EnabledWeekDays enabledWeekDays,
    required bool isFeatureEnabled,
    required Iterable<Date> eventDatesInCurrentWeek,
  }) {
    if (!isFeatureEnabled) return false;
    final enabledDays = enabledWeekDays.getEnabledWeekDaysList();
    if (enabledDays.isEmpty) return false;
    final lastEnabledIndex = enabledDays.map((day) => day.index).reduce(max);
    if (today.weekDayEnum.index <= lastEnabledIndex) return false;
    final hasUpcomingEventOnNonEnabledDay = eventDatesInCurrentWeek.any((
      eventDate,
    ) {
      final isEnabledDay =
          enabledWeekDays.getValue(eventDate.weekDayEnum) ?? false;
      if (isEnabledDay) return false;
      return !eventDate.isBefore(today);
    });
    return !hasUpcomingEventOnNonEnabledDay;
  }

  // THERE ARE MORE OPTIMAL CALCULATION METHODES, BUT I LIKE THIS DESIGN :)
  static List<Date> generateDaysList(
    Date startDate,
    Date endDate,
    EnabledWeekDays enabledWeekDays,
  ) {
    DateTime startDateTime = startDate.toDateTime;
    DateTime endDateTime = endDate.toDateTime;
    int days = endDateTime.difference(startDateTime).inDays.abs() + 1;
    return List.generate(
      days,
      (it) => Date.fromDateTime(startDateTime.add(Duration(days: it))),
    ).where((it) => enabledWeekDays.getValue(it.weekDayEnum)!).toList();
  }

  static String getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'Mo';
      case 2:
        return 'Di';
      case 3:
        return 'Mi';
      case 4:
        return 'Do';
      case 5:
        return 'Fr';
      case 6:
        return 'Sa';
      case 7:
        return 'So';
      default:
        return "falsedayValue!";
    }
  }
}
