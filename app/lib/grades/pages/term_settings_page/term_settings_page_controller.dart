// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_view.dart';

class TermSettingsPageController extends ChangeNotifier {
  final GradesService gradesService;
  final TermId termId;

  late String name;
  late bool isActiveTerm;
  late GradingSystem gradingSystem;
  late GradeType finalGradeType;
  late IMap<GradeTypeId, Weight> _weights;

  TermSettingsState state = const TermSettingsLoading();

  TermSettingsPageView get view => TermSettingsPageView(
        isActiveTerm: isActiveTerm,
        name: name,
        gradingSystem: gradingSystem,
        finalGradeType: finalGradeType,
        selectableGradingTypes: gradesService.getPossibleGradeTypes(),
        weights: _weights,
        subjects: (_getTerm()?.subjects ?? IList())
            .map((s) => (
                  id: s.id,
                  design: s.design,
                  displayName: s.name,
                  abbreviation: s.abbreviation,
                  weight: s.weightingForTermGrade
                ))
            .toIList(),
      );

  TermSettingsPageController({
    required this.gradesService,
    required this.termId,
  }) {
    final term = _getTerm();
    if (term == null) {
      state = const TermSettingsError('Term not found');
      return;
    }

    name = term.name;
    isActiveTerm = term.isActiveTerm;
    gradingSystem = term.gradingSystem;
    finalGradeType = term.finalGradeType;
    _weights = term.gradeTypeWeightings;

    state = TermSettingsLoaded(view);
  }

  TermResult? _getTerm() {
    return gradesService.terms.value.firstWhereOrNull((t) => t.id == termId);
  }

  void setName(String name) {
    this.name = name;
    gradesService.editTerm(
      id: termId,
      name: name,
    );
    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  void setIsActiveTerm(bool isActiveTerm) {
    this.isActiveTerm = isActiveTerm;
    gradesService.editTerm(
      id: termId,
      isActiveTerm: isActiveTerm,
    );
    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  void setGradingSystem(GradingSystem gradingSystem) {
    this.gradingSystem = gradingSystem;
    gradesService.editTerm(
      id: termId,
      gradingSystem: gradingSystem,
    );
    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  void setFinalGradeType(GradeType gradeType) {
    gradesService.editTerm(
      id: termId,
      finalGradeType: gradeType.id,
    );
    finalGradeType = gradeType;
    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  void setGradeWeight(GradeTypeId gradeTypeId, Weight weight) {
    gradesService.changeGradeTypeWeightForTerm(
      termId: termId,
      gradeType: gradeTypeId,
      weight: weight,
    );
    _weights = _getTerm()!.gradeTypeWeightings;
    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  void removeGradeType(GradeTypeId gradeTypeId) {
    gradesService.removeGradeTypeWeightForTerm(
      termId: termId,
      gradeType: gradeTypeId,
    );
    _weights = _getTerm()!.gradeTypeWeightings;
    state = TermSettingsLoaded(view);
    notifyListeners();
  }

  void setSubjectWeight(SubjectId subjectId, Weight weight) {
    gradesService.changeSubjectWeightForTermGrade(
      id: subjectId,
      termId: termId,
      weight: weight,
    );
    state = TermSettingsLoaded(view);
    notifyListeners();
  }
}

sealed class TermSettingsState {
  const TermSettingsState();
}

class TermSettingsLoading extends TermSettingsState {
  const TermSettingsLoading();
}

class TermSettingsLoaded extends TermSettingsState {
  final TermSettingsPageView view;

  const TermSettingsLoaded(this.view);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TermSettingsLoaded && other.view == view;
  }

  @override
  int get hashCode => view.hashCode;
}

class TermSettingsError extends TermSettingsState {
  final String message;

  const TermSettingsError(this.message);
}
