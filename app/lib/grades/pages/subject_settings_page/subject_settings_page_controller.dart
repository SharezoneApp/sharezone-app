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
import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';

class SubjectSettingsPageController extends ChangeNotifier {
  final GradesService gradesService;
  SubjectId get subjectId => subRef.id;
  final TermSubjectRef subRef;
  TermId get termId => subRef.termRef.id;

  SubjectSettingsPageController({
    required this.subRef,
    required this.gradesService,
  }) {
    final subject = _getSubject();
    if (subject == null) {
      state = const SubjectSettingsError(
          'We could not find the subject. Please try again.');
      return;
    }

    if (subject.weightType == WeightType.perGrade) {
      state = SubjectSettingsError(
          'Subject "${subject.name}" (id: $subjectId) has its weightType set to ${WeightType.perGrade}. This is not supported (yet).');
      return;
    }

    _subjectName = subject.name;
    final finalGradeType = _getFinalGradeType(subject.finalGradeTypeId);
    _finalGradeTypeDisplayName = _getFinalGradeTypeDisplayName(finalGradeType);
    _finalGradeTypeIcon = _getFinalGradeTypeIcon(finalGradeType);
    _selectableGradeTypes = gradesService.getPossibleGradeTypes();

    // Todo: Explain this workaround
    _weights = IMap();

    if (subject.weightType == WeightType.inheritFromTerm) {
      // We show the weights from the term, but we need to copy them into the
      // subject if the user changes them.
      _weights = _weights.addAll(_getTerm()!.gradeTypeWeightings);
    } else {
      _weights = _weights.addAll(subject.gradeTypeWeights);
    }

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

  /// Copies the weights from the term to the subject if the subject is set to
  /// inherit the weights from the term.
  ///
  /// This method is called before changing the weights of a subject.
  Future<void> _maybeCopyWeightsFromTerm() async {
    if (_getSubject()!.weightType != WeightType.inheritFromTerm) {
      // Subject has its own weights, no need to copy from term.
      return;
    }

    // In the constructor, we already copied the weights from the term. But they
    // were only copied into the state. Now we need to copy them into the
    // database.
    for (final gradeType in _weights.keys) {
      subRef.changeFinalGradeType(gradeType);
      await waitForFirestoreWriteLimit();
    }

    subRef.changeWeightType(WeightType.perGradeType);
    await waitForFirestoreWriteLimit();
  }

  Future<void> setGradeWeight({
    required GradeTypeId gradeTypeId,
    required Weight weight,
  }) async {
    await _maybeCopyWeightsFromTerm();

    subRef.changeGradeTypeWeight(gradeTypeId, weight);
    _selectableGradeTypes = gradesService.getPossibleGradeTypes();
    _weights = _weights.add(gradeTypeId, weight);
    state = SubjectSettingsLoaded(view);
    notifyListeners();
  }

  Future<void> removeGradeType(GradeTypeId gradeTypeId) async {
    await _maybeCopyWeightsFromTerm();

    subRef.removeGradeTypeWeight(gradeTypeId);
    _selectableGradeTypes = gradesService.getPossibleGradeTypes();
    _weights = _weights.remove(gradeTypeId);
    state = SubjectSettingsLoaded(view);
    notifyListeners();
  }

  void setFinalGradeType(GradeType gradeType) {
    _finalGradeTypeDisplayName = _getFinalGradeTypeDisplayName(gradeType);
    _finalGradeTypeIcon = _getFinalGradeTypeIcon(gradeType);
    subRef.changeFinalGradeType(gradeType.id);
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
