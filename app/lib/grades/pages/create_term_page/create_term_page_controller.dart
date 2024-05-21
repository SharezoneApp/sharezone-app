// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:crash_analytics/crash_analytics.dart';
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
      final termRef = gradesService.addTerm(
        name: view.name!,
        isActiveTerm: view.isActiveTerm,
        finalGradeType: GradeType.schoolReportGrade.id,
        gradingSystem: view.gradingSystem,
      );
      analytics.logCreateTerm();

      // Firestore had a soft limit of 1 write per second per document. However,
      // this limit isn't mentioned in the documentation anymore. We still keep
      // the delay to be on the safe side.
      //
      // https://stackoverflow.com/questions/74454570/has-firestore-removed-the-soft-limit-of-1-write-per-second-to-a-single-document
      await _waitForFirestoreLimit();
      termRef.changeGradeTypeWeight(
          GradeType.writtenExam.id, const Weight.percent(50));

      await _waitForFirestoreLimit();
      termRef.changeGradeTypeWeight(
          GradeType.oralParticipation.id, const Weight.percent(50));
    } catch (e, s) {
      crashAnalytics.recordError('Could not save term: $e', s);
      throw CouldNotSaveTermException('$e');
    }
  }

  Future<void> _waitForFirestoreLimit() async {
    await Future.delayed(const Duration(milliseconds: 200));
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
