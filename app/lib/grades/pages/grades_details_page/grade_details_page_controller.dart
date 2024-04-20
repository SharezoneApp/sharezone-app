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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_view.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_view.dart';
import 'package:sharezone/grades/pages/grades_page/grades_page_controller.dart';

class GradeDetailsPageController extends ChangeNotifier {
  final GradeId id;
  final GradesService gradesService;
  final CrashAnalytics crashAnalytics;
  late StreamSubscription<GradeResult?> _gradeStreamSubscription;

  GradeDetailsPageState state = const GradeDetailsPageLoading();

  GradeDetailsPageController({
    required this.id,
    required this.gradesService,
    required this.crashAnalytics,
  }) {
    _gradeStreamSubscription = _getGradeStream().listen((grade) {
      if (grade != null) {
        state = GradeDetailsPageLoaded(
          GradeDetailsView(
            gradeValue: displayGrade(grade.value),
            gradingSystem: grade.gradingSystem.displayName,
            subjectDisplayName: _getSubjectDisplayNameOfGrade(grade.id),
            date: DateFormat.yMd().format(grade.date.toDateTime),
            gradeType: _getGradeTypeDisplayName(grade.gradeTypeId),
            termDisplayName: _getTermDisplayNameOfGrade(grade.id),
            integrateGradeIntoSubjectGrade: grade.isTakenIntoAccount,
            title: grade.title,
            details: grade.details,
          ),
        );
      } else {
        state = const GradeDetailsPageError('Grade not found');
      }
      notifyListeners();
    }, onError: (error, stack) {
      state = GradeDetailsPageError('$error');
      crashAnalytics.recordError(
          'Error while streaming a grade: $error', stack);
      notifyListeners();
    });
  }

  Stream<GradeResult?> _getGradeStream() {
    return gradesService.terms.map((terms) {
      for (final term in terms) {
        final grade = term.subjects
            .map((s) => s.grades.firstWhereOrNull((grade) => grade.id == id))
            .whereNotNull()
            .firstOrNull;
        if (grade != null) {
          return grade;
        }
      }

      // Ground with the [id] not found.
      return null;
    });
  }

  String _getSubjectDisplayNameOfGrade(GradeId gradeId) {
    for (final term in gradesService.terms.value) {
      for (final subject in term.subjects) {
        if (subject.grades.any((grade) => grade.id == gradeId)) {
          return subject.name;
        }
      }
    }
    return '?';
  }

  String _getTermDisplayNameOfGrade(GradeId gradeId) {
    for (final term in gradesService.terms.value) {
      if (term.subjects.any(
          (subject) => subject.grades.any((grade) => grade.id == gradeId))) {
        return term.name;
      }
    }
    return '?';
  }

  String _getGradeTypeDisplayName(GradeTypeId gradeTypeId) {
    const unknown = '?';
    for (final gradeType in GradeType.predefinedGradeTypes) {
      if (gradeType.id == gradeTypeId) {
        return gradeType.predefinedType?.toUiString() ?? unknown;
      }
    }
    return unknown;
  }

  void deleteGrade() {
    gradesService.deleteGrade(id);
  }

  @override
  void dispose() {
    _gradeStreamSubscription.cancel();
    super.dispose();
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
