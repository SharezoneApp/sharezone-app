// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_page/grades_page_controller.dart';
import 'package:sharezone/grades/pages/grades_view.dart';

class TermDetailsPageController extends ChangeNotifier {
  late TermDetailsPageState state = const TermDetailsPageLoading();
  final TermId termId;
  final GradesService gradesService;
  final CrashAnalytics crashAnalytics;
  late StreamSubscription<TermResult?> _termStreamSubscription;

  TermDetailsPageController({
    required this.termId,
    required this.gradesService,
    required this.crashAnalytics,
  }) {
    _termStreamSubscription = _getTermStream(termId).listen((term) {
      if (term == null) {
        state = const TermDetailsPageError('Term not found');
      } else {
        final List<({SubjectView subject, List<SavedGradeView> grades})>
            subjects2 = term.subjects.map((subject) {
          return (
            subject: (
              id: subject.id,
              abbreviation: subject.abbreviation,
              displayName: subject.name,
              grade: displayGrade(subject.calculatedGrade),
              design: subject.design,
            ),
            grades: subject.grades
                .map((grade) => (
                      id: grade.id,
                      grade: displayGrade(grade.value),
                      gradeTypeIcon: const Icon(Icons.note_add),
                      title: grade.title,
                      date: grade.date,
                    ))
                .toList()
          );
        }).toList();

        state = TermDetailsPageLoaded(
          term: (
            id: term.id,
            displayName: term.name,
            avgGrade: (
              displayGrade(term.calculatedGrade),
              GradePerformance.good,
            ),
          ),
          subjectsWithGrades: subjects2,
        );
      }
      notifyListeners();
    }, onError: (error, stack) {
      state = TermDetailsPageError(error);
      crashAnalytics.recordError('Could not stream term: $error', stack);
      notifyListeners();
    });
  }

  Stream<TermResult?> _getTermStream(TermId termId) {
    return gradesService.terms
        .map((terms) => terms.firstWhereOrNull((term) => term.id == termId));
  }

  @override
  void dispose() {
    _termStreamSubscription.cancel();
    super.dispose();
  }
}

sealed class TermDetailsPageState {
  const TermDetailsPageState();
}

class TermDetailsPageLoading extends TermDetailsPageState {
  const TermDetailsPageLoading();
}

typedef SavedGradeView = ({
  GradeId id,
  GradeView grade,
  Icon gradeTypeIcon,
  String title,
  Date date,
});

class TermDetailsPageLoaded extends TermDetailsPageState {
  final PastTermView term;
  final List<({SubjectView subject, List<SavedGradeView> grades})>
      subjectsWithGrades;

  const TermDetailsPageLoaded({
    required this.term,
    required this.subjectsWithGrades,
  });
}

class TermDetailsPageError extends TermDetailsPageState {
  final String error;

  const TermDetailsPageError(this.error);
}
