// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
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
    isActiveTerm: false,
    nameErrorText: null,
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
      view = view.copyWith(nameErrorText: () => 'Bitte gib einen Namen ein');
    } else {
      view = view.copyWith(nameErrorText: () => null);
    }
  }

  void setIsCurrentTerm(bool isCurrentTerm) {
    view = view.copyWith(isActiveTerm: isCurrentTerm);
    notifyListeners();
  }

  void save() {
    _validateName();
    if (!view.isNameValid) {
      throw InvalidTermNameException();
    }

    try {
      final termId = TermId(Id.generate().id);
      gradesService.addTerm(
        id: termId,
        name: view.name!,
        isActiveTerm: view.isActiveTerm,
        finalGradeType: const GradeTypeId('school-report-grade'),
        gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
      );
      analytics.logCreateTerm();
    } catch (e, s) {
      crashAnalytics.recordError('Could not save term: $e', s);
      throw CouldNotSaveTermException('$e');
    }
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
