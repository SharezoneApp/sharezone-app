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

class StudentHomeworkViewFactory {
  late Date Function() _getCurrentDate;

  /// The color value from `color.value`.
  /// E.g. "0xFF03A9F4" for light blue.
  final int defaultColorValue;
  final Color defaultColor;

  StudentHomeworkViewFactory({
    Date Function()? getCurrentDate,
    required this.defaultColorValue,
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
      todoDate: homework.todoDate,
      withSubmissions: homework.withSubmissions,
      isCompleted: homework.status == CompletionStatus.completed,
      colorDate: homework.isOverdueRelativeTo(twoDaysInFuture),
      subjectColor: homework.subject.color ?? defaultColor,
    );
  }
}
