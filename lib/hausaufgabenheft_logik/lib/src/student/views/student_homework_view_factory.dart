// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/shared/models/homework.dart';
import 'package:hausaufgabenheft_logik/src/shared/models/models.dart';
import 'package:hausaufgabenheft_logik/src/shared/color.dart';
import 'package:hausaufgabenheft_logik/src/student/views/student_homework_view.dart';
import 'package:intl/intl.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

class StudentHomeworkViewFactory {
  late Date Function() _getCurrentDate;

  /// The color value from `color.value`.
  /// E.g. "0xFF03A9F4" for light blue.
  final int defaultColorValue;
  final Color defaultColor;
  final SharezoneLocalizations l10n;

  StudentHomeworkViewFactory({
    Date Function()? getCurrentDate,
    required this.defaultColorValue,
    required this.l10n,
  }) : defaultColor = Color(defaultColorValue) {
    if (getCurrentDate == null) {
      _getCurrentDate = () => Date.now();
    } else {
      _getCurrentDate = getCurrentDate;
    }
  }

  StudentHomeworkView createFrom(StudentHomeworkReadModel homework) {
    final twoDaysInFuture = _getCurrentDate().addDays(2);
    return StudentHomeworkView(
      id: homework.id.toString(),
      title: homework.title.value,
      subject: homework.subject.name,
      abbreviation: homework.subject.abbreviation,
      todoDate: _getLocaleDateString(
        Date.fromDateTime(homework.todoDate),
        time: _getTime(homework.withSubmissions, homework.todoDate),
      ),
      withSubmissions: homework.withSubmissions,
      isCompleted: homework.status == CompletionStatus.completed,
      colorDate: homework.isOverdueRelativeTo(twoDaysInFuture),
      subjectColor: homework.subject.color ?? defaultColor,
    );
  }

  String _getLocaleDateString(Date date, {String? time}) {
    final dateTime = date.asDateTime();
    final localeName = l10n.localeName;
    final weekday = DateFormat.E(localeName).format(dateTime);
    final day = date.day.toString();
    final month = DateFormat.MMM(localeName).format(dateTime);
    final yearSuffix = (date.year % 100).toString().padLeft(2, '0');

    final dateString = l10n.homeworkStudentDueDate(
      weekday,
      day,
      month,
      yearSuffix,
    );
    if (time == null) return dateString;
    return l10n.homeworkDueDateWithTime(dateString, time);
  }

  String? _getTime(bool withSubmissions, DateTime dateTime) {
    if (!withSubmissions) return null;
    return DateFormat.jm(l10n.localeName).format(dateTime);
  }
}
