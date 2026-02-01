// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

enum WeekDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

String weekDayEnumToLocalizedString(BuildContext context, WeekDay weekDay) {
  final l10n = context.l10n;
  switch (weekDay) {
    case WeekDay.monday:
      return l10n.dateWeekdayMonday;
    case WeekDay.tuesday:
      return l10n.dateWeekdayTuesday;
    case WeekDay.wednesday:
      return l10n.dateWeekdayWednesday;
    case WeekDay.thursday:
      return l10n.dateWeekdayThursday;
    case WeekDay.friday:
      return l10n.dateWeekdayFriday;
    case WeekDay.saturday:
      return l10n.dateWeekdaySaturday;
    case WeekDay.sunday:
      return l10n.dateWeekdaySunday;
  }
}
