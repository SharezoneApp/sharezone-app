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
import 'package:sharezone/grades/pages/subject_settings_page/subject_settings_page_view.dart';

class SubjectSettingsPageController extends ChangeNotifier {
  final GradesService gradesService;
  final SubjectId subjectId;
  final TermId termId;

  SubjectSettingsPageController({
    required this.subjectId,
    required this.termId,
    required this.gradesService,
  }) {
    final subject = _getSubject();
    if (subject == null) {
      state = const SubjectSettingsError(
          'We could not find the subject. Please try again.');
      return;
    }

    _subjectName = subject.name;
    final finalGradeType = _getFinalGradeType(subject.finalGradeTypeId);
    _finalGradeTypeDisplayName = _getFinalGradeTypeDisplayName(finalGradeType);
    _finalGradeTypeIcon = _getFinalGradeTypeIcon(finalGradeType);
    _selectableGradeTypes = gradesService.getPossibleGradeTypes();
    _weights = subject.gradeTypeWeights;

    state = SubjectSettingsLoaded(view);
  }

  TermResult? _getTerm() {
    return gradesService.terms.value
        .firstWhereOrNull((term) => term.id == termId);
  }

  SubjectResult? _getSubject() {
    final term = _getTerm();
    if (term == null) {
      return null;
    }

    try {
      return term.subject(subjectId);
    } catch (e) {
      return null;
    }
  }

  String _getFinalGradeTypeDisplayName(GradeType? gradeType) {
    return gradeType?.predefinedType?.toUiString() ?? '?';
  }

  Icon _getFinalGradeTypeIcon(GradeType? gradeType) {
    return gradeType?.predefinedType?.getIcon() ?? const Icon(Icons.help);
  }

  GradeType? _getFinalGradeType(GradeTypeId gradeTypeId) {
    for (final gradeType in GradeType.predefinedGradeTypes) {
      if (gradeType.id == gradeTypeId) {
        return gradeType;
      }
    }
    return null;
  }

  SubjectSettingsState state = const SubjectSettingsLoading();

  late String _subjectName;
  late String _finalGradeTypeDisplayName;
  late Icon _finalGradeTypeIcon;
  late IList<GradeType> _selectableGradeTypes;
  late IMap<GradeTypeId, Weight> _weights;

  SubjectSettingsPageView get view {
    return SubjectSettingsPageView(
      subjectName: _subjectName,
      finalGradeTypeDisplayName: _finalGradeTypeDisplayName,
      finalGradeTypeIcon: _finalGradeTypeIcon,
      selectableGradingTypes: _selectableGradeTypes.where((gradeType) {
        return !_weights.containsKey(gradeType.id);
      }).toIList(),
      weights: _weights,
    );
  }

  void setGradeWeight({
    required GradeTypeId gradeTypeId,
    required Weight weight,
  }) {
    gradesService.changeGradeTypeWeightForSubject(
      id: subjectId,
      termId: termId,
      gradeType: gradeTypeId,
      weight: weight,
    );
    _selectableGradeTypes = gradesService.getPossibleGradeTypes();
    _weights = _getSubject()!.gradeTypeWeights;
    state = SubjectSettingsLoaded(view);
    notifyListeners();
  }

  void removeGradeType(GradeTypeId gradeTypeId) {
    gradesService.removeGradeTypeWeightForSubject(
      id: subjectId,
      termId: termId,
      gradeType: gradeTypeId,
    );
    _selectableGradeTypes = gradesService.getPossibleGradeTypes();
    _weights = _getSubject()!.gradeTypeWeights;
    state = SubjectSettingsLoaded(view);
    notifyListeners();
  }

  void setFinalGradeType(GradeType gradeType) {
    _finalGradeTypeDisplayName = _getFinalGradeTypeDisplayName(gradeType);
    _finalGradeTypeIcon = _getFinalGradeTypeIcon(gradeType);
    gradesService.changeSubjectFinalGradeType(
      id: subjectId,
      termId: termId,
      gradeType: gradeType.id,
    );
    state = SubjectSettingsLoaded(view);
    notifyListeners();
  }
}

sealed class SubjectSettingsState {
  const SubjectSettingsState();
}

class SubjectSettingsLoading extends SubjectSettingsState {
  const SubjectSettingsLoading();
}

class SubjectSettingsLoaded extends SubjectSettingsState {
  final SubjectSettingsPageView view;

  const SubjectSettingsLoaded(this.view);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubjectSettingsLoaded && other.view == view;
  }

  @override
  int get hashCode => view.hashCode;
}

class SubjectSettingsError extends SubjectSettingsState {
  final String message;

  const SubjectSettingsError(this.message);
}
