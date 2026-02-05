// Copyright (c) 2026 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:intl/intl.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

String formatHomeworkTodoDate(
  BuildContext context,
  DateTime todoDate,
  bool withSubmissions,
) {
  final localeName = Localizations.localeOf(context).toString();
  final dateString = DateFormat.yMMMd(localeName).format(todoDate);
  if (!withSubmissions) return dateString;
  final timeString = DateFormat.jm(localeName).format(todoDate);
  return context.l10n.homeworkTodoDateTime(dateString, timeString);
}

String homeworkSectionTitle(
  BuildContext context,
  HomeworkSectionView<dynamic> section,
) {
  final l10n = context.l10n;
  switch (section.type) {
    case HomeworkSectionType.date:
      switch (section.dateSection!) {
        case HomeworkDateSection.overdue:
          return l10n.homeworkSectionOverdue;
        case HomeworkDateSection.today:
          return l10n.homeworkSectionToday;
        case HomeworkDateSection.tomorrow:
          return l10n.homeworkSectionTomorrow;
        case HomeworkDateSection.dayAfterTomorrow:
          return l10n.homeworkSectionDayAfterTomorrow;
        case HomeworkDateSection.later:
          return l10n.homeworkSectionLater;
      }
    case HomeworkSectionType.weekday:
      final localeName = Localizations.localeOf(context).toString();
      final referenceDate = DateTime.utc(2020, 1, 6 + (section.weekday! - 1));
      return DateFormat.EEEE(localeName).format(referenceDate);
    case HomeworkSectionType.subject:
    case HomeworkSectionType.custom:
      return section.title ?? '';
  }
}
