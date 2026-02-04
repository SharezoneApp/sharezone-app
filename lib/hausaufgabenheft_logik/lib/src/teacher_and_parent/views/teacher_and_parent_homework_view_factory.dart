// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/shared/models/models.dart';
import 'package:hausaufgabenheft_logik/src/shared/color.dart';

import '../../../hausaufgabenheft_logik_lehrer.dart';

class TeacherAndParentHomeworkViewFactory {
  late Date Function() _getCurrentDate;

  /// The color value from `color.value`.
  /// E.g. "0xFF03A9F4" for light blue.
  final int defaultColorValue;
  final Color defaultColor;

  TeacherAndParentHomeworkViewFactory({
    Date Function()? getCurrentDate,
    required this.defaultColorValue,
  }) : defaultColor = Color(defaultColorValue) {
    if (getCurrentDate == null) {
      _getCurrentDate = () => Date.now();
    } else {
      _getCurrentDate = getCurrentDate;
    }
  }

  TeacherAndParentHomeworkView createFrom(TeacherHomeworkReadModel homework) {
    final twoDaysInFuture = _getCurrentDate().addDays(2);
    return TeacherAndParentHomeworkView(
      id: homework.id,
      title: homework.title.value,
      subject: homework.subject.name,
      abbreviation: homework.subject.abbreviation,
      todoDate: homework.todoDate,
      withSubmissions: homework.withSubmissions,
      nrOfStudentsCompletedOrSubmitted: homework.nrOfStudentsCompleted,
      canViewCompletionOrSubmissionList:
          homework.withSubmissions
              ? homework.canViewSubmissions
              : homework.canViewCompletions,
      colorDate: homework.isOverdueRelativeTo(twoDaysInFuture),
      subjectColor: homework.subject.color ?? defaultColor,
      canDeleteForEveryone: false,
      canEditForEveryone: false,
    );
  }
}
