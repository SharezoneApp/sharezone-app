// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

enum WeekDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

String weekDayEnumToGermanString(WeekDay weekDay) {
  switch (weekDay) {
    case WeekDay.monday:
      return 'Montag';
    case WeekDay.tuesday:
      return 'Dienstag';
    case WeekDay.wednesday:
      return 'Mittwoch';
    case WeekDay.thursday:
      return 'Donnerstag';
    case WeekDay.friday:
      return 'Freitag';
    case WeekDay.saturday:
      return 'Samstag';
    case WeekDay.sunday:
      return 'Sonntag';
  }
}
