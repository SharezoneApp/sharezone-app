// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_view.dart';
import 'package:sharezone/grades/pages/grades_page/grades_page_controller.dart';

class GradeDetailsPageController extends ChangeNotifier {
  final GradeId id;
  final GradesService gradesService;

  GradeDetailsPageState state = const GradeDetailsPageLoading();

  GradeDetailsPageController({
    required this.id,
    required this.gradesService,
  }) {
    try {
      final grade = gradesService.getGrade(id);
      state = GradeDetailsPageLoaded(
        GradeDetailsView(
          gradeValue: displayGrade(grade.value),
          gradingSystem: grade.gradingSystem.name,
          subjectDisplayName: '?',
          date: DateFormat.yMd().format(grade.date.toDateTime),
          gradeType: '?',
          termDisplayName: '?',
          integrateGradeIntoSubjectGrade: grade.isTakenIntoAccount,
          title: grade.title,
          details: 'todo',
        ),
      );
    } catch (e) {
      state = GradeDetailsPageError('$e');
    } finally {
      notifyListeners();
    }
  }

  void deleteGrade() {
    gradesService.deleteGrade(id);
  }
}

sealed class GradeDetailsPageState {
  const GradeDetailsPageState();
}

class GradeDetailsPageLoading extends GradeDetailsPageState {
  const GradeDetailsPageLoading();
}

class GradeDetailsPageError extends GradeDetailsPageState {
  final String message;

  const GradeDetailsPageError(this.message);
}

class GradeDetailsPageLoaded extends GradeDetailsPageState {
  final GradeDetailsView view;

  const GradeDetailsPageLoaded(this.view);
}
