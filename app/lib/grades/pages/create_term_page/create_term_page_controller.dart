// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:crash_analytics/crash_analytics.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_analytics.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_page_view.dart';

class CreateTermPageController extends ChangeNotifier {
  final GradesService gradesService;
  final CreateTermAnalytics analytics;
  final CrashAnalytics crashAnalytics;

  CreateTermPageView view = const CreateTermPageView(
    name: null,
    isActiveTerm: true,
    nameErrorText: null,
    gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
  );

  CreateTermPageController({
    required this.gradesService,
    required this.analytics,
    required this.crashAnalytics,
  });

  void setName(String name) {
    view = view.copyWith(name: name);
    _validateName();
    notifyListeners();
  }

  void _validateName() {
    if (view.name == null || view.name!.isEmpty) {
      view = view.copyWith(nameErrorText: () => 'Bitte gib einen Namen ein.');
    } else {
      view = view.copyWith(nameErrorText: () => null);
    }
  }

  void setIsCurrentTerm(bool isCurrentTerm) {
    view = view.copyWith(isActiveTerm: isCurrentTerm);
    notifyListeners();
  }

  Future<void> save() async {
    _validateName();
    if (!view.isNameValid) {
      throw InvalidTermNameException();
    }

    try {
      gradesService.addTerm(
        name: view.name!,
        isActiveTerm: view.isActiveTerm,
        finalGradeType: GradeType.schoolReportGrade.id,
        gradingSystem: view.gradingSystem,
        gradeTypeWeights: IMap({
          GradeType.writtenExam.id: const Weight.percent(50),
          GradeType.oralParticipation.id: const Weight.percent(50),
        }),
      );
      analytics.logCreateTerm();
    } catch (e, s) {
      crashAnalytics.recordError('Could not save term: $e', s);
      throw CouldNotSaveTermException('$e');
    }
  }

  void setGradingSystem(GradingSystem system) {
    view = view.copyWith(gradingSystem: system);
    notifyListeners();
  }
}

sealed class TermException implements Exception {}

class CouldNotSaveTermException implements TermException {
  final String message;

  CouldNotSaveTermException(this.message);
}

class InvalidTermNameException implements TermException {
  InvalidTermNameException();
}
