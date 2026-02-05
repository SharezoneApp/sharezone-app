// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String toLocalizedString(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      WeekDay.monday => l10n.dateWeekdayMonday,
      WeekDay.tuesday => l10n.dateWeekdayTuesday,
      WeekDay.wednesday => l10n.dateWeekdayWednesday,
      WeekDay.thursday => l10n.dateWeekdayThursday,
      WeekDay.friday => l10n.dateWeekdayFriday,
      WeekDay.saturday => l10n.dateWeekdaySaturday,
      WeekDay.sunday => l10n.dateWeekdaySunday,
    };
  }
}
