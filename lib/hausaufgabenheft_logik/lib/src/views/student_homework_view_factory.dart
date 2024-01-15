// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/models/homework/homework.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/models_used_by_homework.dart';
import 'package:hausaufgabenheft_logik/src/views/color.dart';
import 'package:hausaufgabenheft_logik/src/views/homework_view.dart';

class StudentHomeworkViewFactory {
  late Date Function() _getCurrentDate;

  /// The color value from `color.value`.
  /// E.g. "0xFF03A9F4" for light blue.
  final int defaultColorValue;
  final Color defaultColor;

  StudentHomeworkViewFactory(
      {Date Function()? getCurrentDate, required this.defaultColorValue})
      : defaultColor = Color(defaultColorValue) {
    if (getCurrentDate == null) {
      _getCurrentDate = () => Date.now();
    } else {
      _getCurrentDate = getCurrentDate;
    }
  }

  StudentHomeworkView createFrom(HomeworkReadModel homework) {
    final twoDaysInFuture = _getCurrentDate().addDays(2);
    return StudentHomeworkView(
      id: homework.id.toString(),
      title: homework.title.value,
      subject: homework.subject.name,
      abbreviation: homework.subject.abbreviation,
      todoDate: _getLocaleDateString(Date.fromDateTime(homework.todoDate),
          time: _getTime(homework.withSubmissions, homework.todoDate)),
      withSubmissions: homework.withSubmissions,
      isCompleted: homework.status == CompletionStatus.completed,
      colorDate: homework.isOverdueRelativeTo(twoDaysInFuture),
      subjectColor: homework.subject.color ?? defaultColor,
    );
  }

  String _getLocaleDateString(Date date, {String? time}) {
    final months = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mär',
      4: 'Apr',
      5: 'Mai',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Okt',
      11: 'Nov',
      12: 'Dez',
    };
    assert(months.containsKey(date.month));

    final day = date.day.toString();
    final month = months[date.month];
    // The year suffix is the last two digits of the year, e.g. 2019 -> 19
    final yearSuffix = date.year.toString().substring(2);

    final weekdays = {
      1: 'Mo',
      2: 'Di',
      3: 'Mi',
      4: 'Do',
      5: 'Fr',
      6: 'Sa',
      7: 'So',
    };
    final weekday = weekdays[date.asDateTime().weekday];

    final dateString = '$weekday, $day. $month $yearSuffix';
    if (time == null) return dateString;
    return '$dateString - $time Uhr';
  }

  String? _getTime(bool withSubmissions, DateTime dateTime) {
    if (!withSubmissions) return null;
    return '${dateTime.hour}:${_getMinute(dateTime.minute)}';
  }

  String _getMinute(int minute) {
    if (minute >= 10) return minute.toString();
    return '0$minute';
  }
}
