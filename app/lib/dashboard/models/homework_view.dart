// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';

import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:intl/intl.dart';
import 'package:sharezone/util/api/course_gateway.dart';

class HomeworkView {
  final String courseName, title;
  final Color todoUntilColor, courseNameColor;

  /// Example: Überfällig, bis heute, bis morgen, bis übermorgen
  final String todoUntilText;

  /// The homework object is in the view needed, to open the homework dialog
  /// and to create the homework card bloc.
  final HomeworkDto homework;

  HomeworkView({
    required this.courseName,
    required this.courseNameColor,
    required this.title,
    required this.todoUntilColor,
    required this.homework,
    required this.todoUntilText,
  });

  static String _getTodoUntilText(
      DateTime dateTime, bool withTodoUntilTextUrgentColor) {
    if (!withTodoUntilTextUrgentColor) {
      return _convertDateTimeIntoFormattedString(dateTime);
    }

    final todayDateTimeWithoutTime =
        DateTime(clock.now().year, clock.now().month, clock.now().day);
    if (dateTime.isBefore(todayDateTimeWithoutTime)) {
      return "Überfällig!";
    } else if (dateTime.isAtSameMomentAs(todayDateTimeWithoutTime)) {
      return "Bis heute!";
    } else if (dateTime.isAtSameMomentAs(
        todayDateTimeWithoutTime.add(const Duration(days: 1)))) {
      return "Bis morgen!";
    } else if (dateTime.isAtSameMomentAs(
        todayDateTimeWithoutTime.add(const Duration(days: 2)))) {
      return "Bis übermorgen!";
    } else {
      return _convertDateTimeIntoFormattedString(dateTime);
    }
  }

  static String _convertDateTimeIntoFormattedString(DateTime dateTime) =>
      DateFormat.yMMMd().format(dateTime);

  static Color _getTodoUntilColor(DateTime dateTime, bool withUrgentColor) {
    final defaultColor = Colors.grey[400]!;
    if (!withUrgentColor) return defaultColor;

    final dayAfterTomorrow =
        DateTime(clock.now().year, clock.now().month, clock.now().day + 2);
    return dateTime.isBefore(dayAfterTomorrow)
        ? Colors.redAccent
        : defaultColor;
  }

  static Color _getCourseColor(String courseID, CourseGateway courseGateway) {
    final course = courseGateway.getCourse(courseID) ?? Course.create();
    final color = course.getDesign().color;
    return color;
  }

  /// [withTodoUntilTextUrgentColor] means, if it is true, the todoUntil date for homeworks, which are urgent,
  /// will be marked with a red color. Other homeworks will be marked
  /// with a grey color.
  HomeworkView.fromHomework(this.homework, CourseGateway courseGateway,
      {bool withTodoUntilTextUrgentColor = true})
      : courseName = homework.courseName,
        courseNameColor = _getCourseColor(homework.courseID, courseGateway),
        title = homework.title,
        todoUntilColor = _getTodoUntilColor(
            homework.todoUntil, withTodoUntilTextUrgentColor),
        todoUntilText =
            _getTodoUntilText(homework.todoUntil, withTodoUntilTextUrgentColor);
}
