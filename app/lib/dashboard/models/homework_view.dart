import 'dart:ui';

import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/util/api/courseGateway.dart';

class HomeworkView {
  final String courseName, title;
  final Color todoUntilColor, courseNameColor;

  /// Example: Überfällig, bis heute, bis moregen, bis übermogen
  final String todoUntilText;

  /// The homework object is in the view needed, to open the homework dialog
  /// and to create the homework card bloc.
  final HomeworkDto homework;

  HomeworkView(
      {@required this.courseName,
      @required this.courseNameColor,
      @required this.title,
      @required this.todoUntilColor,
      @required this.homework,
      @required this.todoUntilText});

  static String _getTodoUntilText(
      DateTime dateTime, bool withTodoUntilTextUrgentColor) {
    if (!withTodoUntilTextUrgentColor)
      return _convertDateTimeIntoFormattedString(dateTime);

    final todayDateTimeWithoutTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (dateTime.isBefore(todayDateTimeWithoutTime))
      return "Überfällig!";
    else if (dateTime.isAtSameMomentAs(todayDateTimeWithoutTime))
      return "Bis heute!";
    else if (dateTime
        .isAtSameMomentAs(todayDateTimeWithoutTime.add(Duration(days: 1))))
      return "Bis morgen!";
    else if (dateTime
        .isAtSameMomentAs(todayDateTimeWithoutTime.add(Duration(days: 2))))
      return "Bis übermorgen!";
    else
      return _convertDateTimeIntoFormattedString(dateTime);
  }

  static String _convertDateTimeIntoFormattedString(DateTime dateTime) =>
      DateFormat.yMMMd().format(dateTime);

  static Color _getTodoUntilColor(DateTime dateTime, bool withUrgentColor) {
    final defaultColor = Colors.grey[400];
    if (!withUrgentColor) return defaultColor;

    final dayAfterTomorrow = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 2);
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
