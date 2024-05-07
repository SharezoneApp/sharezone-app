// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';
import 'package:collection/collection.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart' as rx;
import 'package:sharezone/grades/models/grade_id.dart';

import '../models/subject_id.dart';
import '../models/term_id.dart';

export '../models/grade_id.dart';
export '../models/subject_id.dart';
export '../models/term_id.dart';

part 'src/grades_repository.dart';
part 'src/grading_systems.dart';
part 'src/term.dart';

class GradesService {
  final rx.BehaviorSubject<IList<TermResult>> terms;
  final GradesStateRepository _repository;

  GradesService({GradesStateRepository? repository})
      : _repository = repository ?? InMemoryGradesStateRepository(),
        terms = rx.BehaviorSubject.seeded(const IListConst([])) {
    _repository.state.listen((state) {
      _updateView();
    });

    _updateView();
  }

  GradesState get _state => _repository.state.value;

  IList<TermModel> get _terms => _state.terms;

  IList<Subject> get _subjects => _state.subjects;

  IList<GradeType> get _customGradeTypes => _state.customGradeTypes;

  void _updateState(GradesState state) {
    _repository.updateState(state);
    // Removing this breaks our tests because they assume that the state is
    // updated synchronously. Usually calling [_updateView] in the .listen from
    // the repository would be enough.
    _updateView();
  }

  void _updateTerms(IList<TermModel> terms) {
    final newState = _state.copyWith(terms: terms);
    _updateState(newState);
  }

  void _updateView() {
    final termRes = _terms.map(_toTermResult).toIList();
    terms.add(termRes);
  }

  void _updateTerm(TermModel term) {
    final newTerms = _terms.replaceAllWhere((t) => t.id == term.id, term);
    _updateTerms(newTerms);
  }

  TermResult _toTermResult(TermModel term) {
    return TermResult(
      id: term.id,
      name: term.name,
      isActiveTerm: term.isActiveTerm,
      finalGradeType: _getGradeType(term.finalGradeType),
      gradingSystem: term.gradingSystem.toGradingSystem(),
      calculatedGrade: term.tryGetTermGrade() != null
          ? term.gradingSystem.toGradeResult(term.tryGetTermGrade()!)
          : null,
      gradeTypeWeightings: term.gradeTypeWeightings,
      subjects: term.subjects
          .map(
            (subject) => SubjectResult(
              id: subject.id,
              name: subject.name,
              design: subject.design,
              abbreviation: subject.abbreviation,
              connectedCourses: subject.connectedCourses,
              calculatedGrade: subject.gradeVal != null
                  ? subject.gradingSystem.toGradeResult(subject.gradeVal!)
                  : null,
              weightType: subject.weightType,
              gradeTypeWeights: subject.gradeTypeWeightings,
              finalGradeTypeId: subject.finalGradeType,
              weightingForTermGrade: subject.weightingForTermGrade,
              grades: subject.grades
                  .map(
                    (grade) => GradeResult(
                      id: grade.id,
                      date: grade.date,
                      isTakenIntoAccount: grade.takenIntoAccount,
                      value: grade.value,
                      title: grade.title,
                      gradeTypeId: grade.gradeType,
                      details: grade.details,
                      originalInput: grade.originalInput,
                    ),
                  )
                  .toIList(),
            ),
          )
          .toIList(),
    );
  }

  TermId addTerm({
    required String name,
    required GradeTypeId finalGradeType,
    required GradingSystem gradingSystem,
    required bool isActiveTerm,
    @visibleForTesting TermId? id,
  }) {
    final termId = id ?? TermId(Id.generate().value);

    IList<TermModel> newTerms = _terms;
    if (isActiveTerm) {
      newTerms = newTerms.map((term) => term.setIsActiveTerm(false)).toIList();
    }

    if (!_hasGradeTypeWithId(finalGradeType)) {
      throw GradeTypeNotFoundException(finalGradeType);
    }

    newTerms = newTerms.add(
      TermModel(
        id: termId,
        isActiveTerm: isActiveTerm,
        name: name,
        finalGradeType: finalGradeType,
        gradingSystem: gradingSystem.toGradingSystemModel(),
      ),
    );
    _updateTerms(newTerms);
    return termId;
  }

  /// Edits the given values of the term (does not edit if the value is null).
  ///
  /// If the term is set to being active, any active term will be set to
  /// inactive. If the term is set to being inactive, nothing will happen to the
  /// other terms.
  ///
  /// Throws [GradeTypeNotFoundException] if the given [finalGradeType] is not
  /// a valid grade type.
  ///
  /// Throws [ArgumentError] if the term with the given [id] does not exist.
  void editTerm({
    required TermId id,
    final bool? isActiveTerm,
    final String? name,
    final GradeTypeId? finalGradeType,
    final GradingSystem? gradingSystem,
  }) {
    IList<TermModel> newTerms = _terms;

    if (isActiveTerm != null) {
      newTerms = newTerms.map((term) {
        if (id == term.id) {
          return term.setIsActiveTerm(isActiveTerm);
        } else {
          // If the term that is edited is set to being active, all other terms
          // should be set to inactive.
          // If the term that is edited is set to being inactive, nothing should
          // happen to the other terms.
          return term.setIsActiveTerm(isActiveTerm ? false : term.isActiveTerm);
        }
      }).toIList();
    }
    if (name != null) {
      newTerms = newTerms
          .map((term) => term.id == id ? term.setName(name) : term)
          .toIList();
    }
    if (finalGradeType != null) {
      if (!_hasGradeTypeWithId(finalGradeType)) {
        throw GradeTypeNotFoundException(finalGradeType);
      }
      newTerms = newTerms
          .map((term) =>
              term.id == id ? term.setFinalGradeType(finalGradeType) : term)
          .toIList();
    }
    if (gradingSystem != null) {
      newTerms = newTerms
          .map((term) => term.id == id
              ? term.setGradingSystem(gradingSystem.toGradingSystemModel())
              : term)
          .toIList();
    }

    _updateTerms(newTerms);
  }

  /// Deletes the term with the given [id] any grades inside it.
  ///
  /// No subjects will be deleted.
  ///
  /// Throws [ArgumentError] if the term with the given [id] does not exist.
  void deleteTerm(TermId id) {
    IList<TermModel> newTerms = _terms;

    final termOrNull = newTerms.firstWhereOrNull((term) => term.id == id);
    if (termOrNull != null) {
      newTerms = _terms.remove(termOrNull);
      _updateTerms(newTerms);
      return;
    }
    throw ArgumentError("Can't delete term, unknown $TermId: '$id'.");
  }

  TermModel _term(TermId id) => _terms.singleWhere((term) => term.id == id);

  void changeSubjectWeightForTermGrade(
      {required SubjectId id, required TermId termId, required Weight weight}) {
    final subject = _getSubjectOrThrow(id);

    var newTerm = _term(termId);
    if (!newTerm.hasSubject(id)) {
      newTerm = newTerm.addSubject(subject);
    }

    newTerm = newTerm.changeWeighting(id, weight);
    _updateTerm(newTerm);
  }

  void changeSubjectWeightTypeSettings(
      {required SubjectId id,
      required TermId termId,
      required WeightType perGradeType}) {
    final newTerm = _term(termId).changeWeightTypeForSubject(id, perGradeType);
    _updateTerm(newTerm);
  }

  void changeGradeTypeWeightForSubject({
    required SubjectId id,
    required TermId termId,
    required GradeTypeId gradeType,
    required Weight weight,
  }) {
    final newTerm = _term(termId)
        .changeWeightingOfGradeTypeInSubject(id, gradeType, weight);
    _updateTerm(newTerm);
  }

  void removeGradeTypeWeightForSubject({
    required SubjectId id,
    required TermId termId,
    required GradeTypeId gradeType,
  }) {
    final newTerm =
        _term(termId).removeWeightingOfGradeTypeInSubject(id, gradeType);
    _updateTerm(newTerm);
  }

  GradeId addGrade({
    required SubjectId subjectId,
    required TermId termId,
    required GradeInput value,
    @visibleForTesting GradeId? id,
  }) {
    final gradeId = id ?? GradeId(Id.generate().value);
    final grade = value.toGrade(gradeId);

    final subject = _getSubjectOrThrow(subjectId);
    if (!_hasGradeTypeWithId(value.type)) {
      throw GradeTypeNotFoundException(value.type);
    }

    if (_hasGradeWithId(gradeId)) {
      throw DuplicateGradeIdException(gradeId);
    }

    var newTerm = _term(termId);
    if (!newTerm.hasSubject(subjectId)) {
      newTerm = newTerm.addSubject(subject);
    }
    newTerm = newTerm.addGrade(grade, toSubject: subjectId);
    _updateTerm(newTerm);

    return gradeId;
  }

  /// Replaces an existing grade with [id] with the [newGrade].
  ///
  /// Throws [GradeNotFoundException] if no grade with the given [id] of
  /// [newGrade] exists.
  ///
  /// Throws [GradeTypeNotFoundException] if the grade type of [newGrade] does
  /// not exist.
  ///
  /// Throws [InvalidGradeValueException] if the [_Grade.value] of the
  /// [newGrade] is not valid for the [_Grade.gradingSystem] of the [newGrade].
  void editGrade(GradeId id, GradeInput newGrade) {
    final grade = newGrade.toGrade(id);

    if (!_hasGradeWithId(id)) {
      throw GradeNotFoundException(id);
    }
    if (!_hasGradeTypeWithId(newGrade.type)) {
      throw GradeTypeNotFoundException(newGrade.type);
    }

    final term = _terms.firstWhere((term) => term.containsGrade(id));
    final newTerm = term.replaceGrade(grade);

    _updateTerm(newTerm);
  }

  void deleteGrade(GradeId gradeId) {
    final term = _terms.firstWhereOrNull((term) => term.hasGrade(gradeId));
    if (term != null) {
      final newTerm = term.removeGrade(gradeId);
      _updateTerm(newTerm);
      return;
    }
    throw GradeNotFoundException(gradeId);
  }

  bool _hasGradeWithId(GradeId id) {
    return _terms.any((term) => term.hasGrade(id));
  }

  void changeGradeWeight({
    required GradeId id,
    required TermId termId,
    required Weight weight,
  }) {
    final subject = _term(termId)
        .subjects
        .where((element) => element.grades.any((grade) => grade.id == id))
        .first;
    final newTerm = _term(termId).changeWeightOfGrade(id, subject.id, weight);

    _updateTerm(newTerm);
  }

  void changeGradeTypeWeightForTerm(
      {required TermId termId,
      required GradeTypeId gradeType,
      required Weight weight}) {
    final newTerm =
        _term(termId).changeWeightingOfGradeType(gradeType, weight: weight);
    _updateTerm(newTerm);
  }

  void removeGradeTypeWeightForTerm({
    required TermId termId,
    required GradeTypeId gradeType,
  }) {
    final newTerm = _term(termId).removeWeightingOfGradeType(gradeType);
    _updateTerm(newTerm);
  }

  void changeSubjectFinalGradeType({
    required SubjectId id,
    required TermId termId,
    required GradeTypeId? gradeType,
  }) {
    if (gradeType == null) {
      final newTerm = _term(termId).subjectInheritFinalGradeTypeFromTerm(id);
      return _updateTerm(newTerm);
    }
    final newTerm = _term(termId).setFinalGradeTypeForSubject(id, gradeType);
    _updateTerm(newTerm);
  }

  /// Returns the possible grades for the given grading system as strings.
  ///
  /// The strings are ordered from the best grade to the worst grade.
  ///
  /// For example the values for the grading system "1-6 with plus and minus"
  /// would be: `['1+', '1', '1-', '2+', [...] '5+', '5', '5-', '6']`
  PossibleGradesResult getPossibleGrades(GradingSystem gradingSystem) {
    final gs = gradingSystem.toGradingSystemModel();
    return gs.possibleGrades;
  }

  IList<GradeType> getPossibleGradeTypes() {
    return GradeType.predefinedGradeTypes.addAll(_customGradeTypes);
  }

  bool _hasGradeTypeWithId(GradeTypeId id) {
    return getPossibleGradeTypes().map((gt) => gt.id).contains(id);
  }

  /// Creates a custom grade type.
  ///
  /// If the grade type already exists, nothing will happen.
  GradeTypeId addCustomGradeType({
    required String displayName,
    @visibleForTesting GradeTypeId? id,
  }) {
    final gradeTypeId = id ?? GradeTypeId(Id.generate().value);
    final gradeType = GradeType(id: gradeTypeId, displayName: displayName);

    if (_hasGradeTypeWithId(gradeTypeId)) {
      // Already exists.
      return gradeTypeId;
    }

    final newState =
        _state.copyWith(customGradeTypes: _customGradeTypes.add(gradeType));
    _updateState(newState);

    return gradeTypeId;
  }

  /// Edits properties of a custom grade type.
  ///
  /// Throws [ArgumentError] if the [displayName] is empty.
  ///
  /// Throws [GradeTypeNotFoundException] if the grade type with the given [id]
  /// does not exist.
  ///
  /// Throws [ArgumentError] if the grade type with the given [id] is a
  /// predefined grade type.
  void editCustomGradeType(
      {required GradeTypeId id, required String displayName}) {
    if (displayName.isEmpty) {
      throw ArgumentError('The display name must not be empty.');
    }

    final isPredefinedGradeType =
        GradeType.predefinedGradeTypes.map((gt) => gt.id).contains(id);
    if (isPredefinedGradeType) {
      throw ArgumentError('Cannot edit a predefined grade type.');
    }
    if (!_hasGradeTypeWithId(id)) {
      throw GradeTypeNotFoundException(id);
    }

    final newCustomGradeTypes = _customGradeTypes.replaceAllWhere(
        (element) => element.id == id,
        GradeType(id: id, displayName: displayName));

    final newState = _state.copyWith(customGradeTypes: newCustomGradeTypes);
    _updateState(newState);
  }

  /// Deletes a custom grade type and removes it from all weight maps.
  ///
  /// A custom grade type can only be deleted if it is not assigned to any grade
  /// or as the final grade type of any term, otherwise a
  /// [GradeTypeStillAssignedException] is thrown.
  ///
  /// Throws [GradeTypeNotFoundException] if the grade type with the given [id]
  /// does not exist.
  ///
  /// Throws [ArgumentError] if the grade type with the given [id] is a
  /// predefined grade type.
  void deleteCustomGradeType(GradeTypeId id) {
    if (GradeType.predefinedGradeTypes.any((gt) => gt.id == id)) {
      throw ArgumentError('Cannot delete a predefined grade type.');
    }
    if (!_hasGradeTypeWithId(id)) {
      throw GradeTypeNotFoundException(id);
    }

    final anyGradeHasGradeTypeAssigned = _terms.any((term) => term.subjects
        .expand((subj) => subj.grades)
        .any((grade) => grade.gradeType == id));
    if (anyGradeHasGradeTypeAssigned) {
      throw GradeTypeStillAssignedException(id);
    }

    if (_terms.any((term) => term.finalGradeType == id)) {
      throw GradeTypeStillAssignedException(id);
    }

    final newTerms = _terms.map((term) {
      var newTerm = term.removeWeightingOfGradeType(id);
      for (var subject in newTerm.subjects) {
        subject = subject.removeGradeTypeWeight(id);
        newTerm = newTerm.replaceSubject(subject);
      }
      return newTerm;
    }).toIList();

    final newCustomGrades = _customGradeTypes.removeWhere((gt) => gt.id == id);

    final newState =
        _state.copyWith(terms: newTerms, customGradeTypes: newCustomGrades);
    _updateState(newState);
  }

  GradeType _getGradeType(GradeTypeId finalGradeType) {
    return getPossibleGradeTypes().firstWhere((gt) => gt.id == finalGradeType);
  }

  SubjectId addSubject(SubjectInput subjectInput,
      {@visibleForTesting SubjectId? id}) {
    final subjectId = id ?? SubjectId(Id.generate().value);
    final subject = subjectInput.toSubject(subjectId);

    if (subject.createdOn != null) {
      throw ArgumentError(
          'The createdOn field should not be set when adding a new subject.');
    }
    if (getSubjects().any((s) => s.id == subjectId)) {
      throw SubjectAlreadyExistsException(subjectId);
    }
    final newState = _state.copyWith(subjects: _subjects.add(subject));
    _updateState(newState);

    return subjectId;
  }

  IList<Subject> getSubjects() {
    return _subjects;
  }

  Subject? getSubject(SubjectId id) {
    return getSubjects().firstWhereOrNull((subject) => subject.id == id);
  }

  Subject _getSubjectOrThrow(SubjectId id) {
    final sub = getSubject(id);
    if (sub == null) {
      throw SubjectNotFoundException(id);
    }
    return sub;
  }
}

class InvalidGradeValueException extends Equatable implements Exception {
  final String gradeInput;
  final GradingSystem gradingSystem;

  const InvalidGradeValueException({
    required this.gradeInput,
    required this.gradingSystem,
  });

  @override
  List<Object?> get props => [gradeInput, gradingSystem];
}

class GradeNotFoundException extends Equatable implements Exception {
  final GradeId id;

  const GradeNotFoundException(this.id);

  @override
  List<Object?> get props => [id];
}

class DuplicateGradeIdException extends Equatable implements Exception {
  final GradeId id;

  const DuplicateGradeIdException(this.id);

  @override
  List<Object?> get props => [id];
}

class SubjectNotFoundException extends Equatable implements Exception {
  final SubjectId id;

  const SubjectNotFoundException(this.id);

  @override
  List<Object?> get props => [id];
}

class SubjectAlreadyExistsException extends Equatable implements Exception {
  final SubjectId id;

  const SubjectAlreadyExistsException(this.id);

  @override
  List<Object?> get props => [id];
}

class GradeTypeNotFoundException extends Equatable implements Exception {
  final GradeTypeId id;

  const GradeTypeNotFoundException(this.id);

  @override
  List<Object?> get props => [id];
}

class GradeTypeStillAssignedException extends Equatable implements Exception {
  final GradeTypeId id;

  const GradeTypeStillAssignedException(this.id);

  @override
  List<Object?> get props => [id];
}

enum GradingSystem {
  oneToSixWithPlusAndMinus(isNumericalAndContinous: true),
  zeroToFifteenPoints(isNumericalAndContinous: true),
  zeroToFifteenPointsWithDecimals(isNumericalAndContinous: true),
  oneToSixWithDecimals(isNumericalAndContinous: true),
  zeroToHundredPercentWithDecimals(isNumericalAndContinous: true),
  oneToFiveWithDecimals(isNumericalAndContinous: true),
  sixToOneWithDecimals(isNumericalAndContinous: true),
  austrianBehaviouralGrades(isNumericalAndContinous: false);

  final bool isNumericalAndContinous;

  const GradingSystem({required this.isNumericalAndContinous});
}

extension NumericalAndContinuous on List<GradingSystem> {
  IList<GradingSystem> get numericalAndContinuous =>
      where((gs) => gs.isNumericalAndContinous).toIList();
}

sealed class PossibleGradesResult extends Equatable {
  const PossibleGradesResult();
}

class NonNumericalPossibleGradesResult extends PossibleGradesResult {
  final IList<String> grades;

  @override
  List<Object?> get props => [grades];

  const NonNumericalPossibleGradesResult(this.grades);
}

class ContinuousNumericalPossibleGradesResult extends PossibleGradesResult {
  final num min;
  final num max;
  final bool decimalsAllowed;

  /// Special non-numerical grade strings that have an assigned numerical value.
  ///
  /// For example [GradingSystem.oneToSixWithPlusAndMinus] might have the values:
  /// `{'1+':0.75,'1-':1.25, /**...*/ '5-':5.25}`.
  final IMap<String, num> specialGrades;

  @override
  List<Object?> get props => [min, max, decimalsAllowed, specialGrades];

  const ContinuousNumericalPossibleGradesResult({
    required this.min,
    required this.max,
    required this.decimalsAllowed,
    this.specialGrades = const IMapConst({}),
  });
}

/// The predefined types of grades that can be used.
///
/// This can be used by the UI to more easily show internationalized names for
/// the predefined grade types.
enum PredefinedGradeTypes {
  schoolReportGrade,
  writtenExam,
  oralParticipation,
  vocabularyTest,
  presentation,
  other;

  String toUiString() {
    return switch (this) {
      PredefinedGradeTypes.schoolReportGrade => 'Zeugnisnote',
      PredefinedGradeTypes.writtenExam => 'Schriftliche Prüfung',
      PredefinedGradeTypes.oralParticipation => 'Mündliche Beteiligung',
      PredefinedGradeTypes.vocabularyTest => 'Vokabeltest',
      PredefinedGradeTypes.presentation => 'Präsentation',
      PredefinedGradeTypes.other => 'Sonstiges',
    };
  }

  Icon getIcon() {
    return switch (this) {
      PredefinedGradeTypes.schoolReportGrade =>
        const Icon(Symbols.contract, fill: 1),
      PredefinedGradeTypes.writtenExam =>
        const Icon(Symbols.edit_document, fill: 1),
      PredefinedGradeTypes.oralParticipation =>
        const Icon(Symbols.record_voice_over, fill: 1),
      PredefinedGradeTypes.vocabularyTest =>
        const Icon(Symbols.text_rotation_none, fill: 1),
      PredefinedGradeTypes.presentation =>
        const Icon(Symbols.co_present, fill: 1),
      PredefinedGradeTypes.other =>
        const Icon(Symbols.other_admission, fill: 1),
    };
  }
}

class GradeType extends Equatable {
  final GradeTypeId id;
  final String? displayName;
  final PredefinedGradeTypes? predefinedType;

  @override
  List<Object?> get props => [id, displayName, predefinedType];

  const GradeType({required this.id, required String this.displayName})
      : predefinedType = null;
  const GradeType._predefined(
      {required this.id, required PredefinedGradeTypes this.predefinedType})
      : displayName = null;

  static const predefinedGradeTypes = IListConst([
    GradeType.schoolReportGrade,
    GradeType.writtenExam,
    GradeType.oralParticipation,
    GradeType.vocabularyTest,
    GradeType.presentation,
    GradeType.other,
  ]);
  static const schoolReportGrade = GradeType._predefined(
      id: GradeTypeId('school-report-grade'),
      predefinedType: PredefinedGradeTypes.schoolReportGrade);
  static const writtenExam = GradeType._predefined(
      id: GradeTypeId('written-exam'),
      predefinedType: PredefinedGradeTypes.writtenExam);
  static const oralParticipation = GradeType._predefined(
      id: GradeTypeId('oral-participation'),
      predefinedType: PredefinedGradeTypes.oralParticipation);
  static const vocabularyTest = GradeType._predefined(
      id: GradeTypeId('vocabulary-test'),
      predefinedType: PredefinedGradeTypes.vocabularyTest);
  static const presentation = GradeType._predefined(
      id: GradeTypeId('presentation'),
      predefinedType: PredefinedGradeTypes.presentation);
  static const other = GradeType._predefined(
      id: GradeTypeId('other'), predefinedType: PredefinedGradeTypes.other);
}

class GradeResult extends Equatable {
  final GradeId id;
  final GradeValue value;
  final bool isTakenIntoAccount;
  final Date date;
  final String title;
  GradingSystem get gradingSystem => value.gradingSystem;
  final GradeTypeId gradeTypeId;
  final String? details;
  final Object originalInput;

  const GradeResult({
    required this.id,
    required this.isTakenIntoAccount,
    required this.value,
    required this.date,
    required this.title,
    required this.gradeTypeId,
    required this.details,
    required this.originalInput,
  });

  @override
  List<Object?> get props => [
        id,
        originalInput,
        value,
        isTakenIntoAccount,
        date,
        title,
        gradeTypeId,
        details,
      ];
}

class SubjectResult extends Equatable {
  final SubjectId id;
  final String name;
  final GradeValue? calculatedGrade;
  final WeightType weightType;
  final IMap<GradeTypeId, Weight> gradeTypeWeights;
  final IList<GradeResult> grades;
  final String abbreviation;
  final Design design;
  final IList<ConnectedCourse> connectedCourses;
  final GradeTypeId finalGradeTypeId;
  final Weight weightingForTermGrade;

  const SubjectResult({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.calculatedGrade,
    required this.weightType,
    required this.gradeTypeWeights,
    required this.grades,
    required this.design,
    required this.connectedCourses,
    required this.finalGradeTypeId,
    required this.weightingForTermGrade,
  });

  GradeResult grade(GradeId gradeId) {
    return grades.firstWhere((element) => element.id == gradeId);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        calculatedGrade,
        connectedCourses,
        weightType,
        gradeTypeWeights,
        grades,
        abbreviation,
        design,
        finalGradeTypeId,
      ];
}

class TermResult extends Equatable {
  final TermId id;
  final GradingSystem gradingSystem;
  final GradeValue? calculatedGrade;
  final IList<SubjectResult> subjects;
  final bool isActiveTerm;
  final String name;
  final GradeType finalGradeType;
  final IMap<GradeTypeId, Weight> gradeTypeWeightings;

  SubjectResult subject(SubjectId id) {
    final subject = subjects.firstWhere((element) => element.id == id);
    return subject;
  }

  const TermResult({
    required this.id,
    required this.gradingSystem,
    required this.name,
    required this.calculatedGrade,
    required this.subjects,
    required this.isActiveTerm,
    required this.finalGradeType,
    required this.gradeTypeWeightings,
  });

  @override
  List<Object?> get props => [
        id,
        gradingSystem,
        calculatedGrade,
        subjects,
        isActiveTerm,
        name,
        finalGradeType,
        gradeTypeWeightings,
      ];
}

class GradeValue extends Equatable {
  double get asDouble => asNum.toDouble();
  final num asNum;

  final GradingSystem gradingSystem;

  /// Only available if there is a special displayable grade for the calculated
  /// grade. For example, if the calculated grade is 2.25, the displayable grade
  /// could be '2+' for the (1-6 with +-) grading system.
  final String? displayableGrade;

  /// A suffix that should be appended to the displayable grade.
  /// For example for the 0-100% grading system, this would be '%'.
  final String? suffix;

  @override
  List<Object?> get props => [asNum, gradingSystem, displayableGrade, suffix];

  const GradeValue({
    required this.asNum,
    required this.gradingSystem,
    required this.displayableGrade,
    required this.suffix,
  });
}

class _Grade extends GradeInput {
  final GradeId id;
  _Grade({
    required this.id,
    required super.value,
    required super.gradingSystem,
    required super.type,
    required super.date,
    required super.takeIntoAccount,
    required super.title,
    required super.details,
  });
}

class GradeInput {
  /// Either a number or a string like '1+', '2-', etc.
  final Object value;
  final GradingSystem gradingSystem;
  final GradeTypeId type;
  final Date date;
  final bool takeIntoAccount;

  /// The title of the grade, for example 'Lineare Algebra Klausur'.
  final String title;

  /// Additional optional details for the grade, for example 'Aufgabe 1: 5/10
  /// Punkte'.
  final String? details;

  GradeInput({
    required this.value,
    required this.gradingSystem,
    required this.type,
    required this.date,
    required this.takeIntoAccount,
    required this.title,
    required this.details,
  });
}

extension on GradeInput {
  _Grade toGrade(GradeId id) {
    return _Grade(
      id: id,
      value: value,
      gradingSystem: gradingSystem,
      type: type,
      date: date,
      takeIntoAccount: takeIntoAccount,
      title: title,
      details: details,
    );
  }
}

enum WeightType {
  perGrade,
  perGradeType,
  inheritFromTerm;
}

class GradeTypeId extends Id {
  const GradeTypeId(super.value);
}

class Subject extends SubjectInput {
  final SubjectId id;

  @override
  List<Object?> get props =>
      [id, design, name, abbreviation, connectedCourses, createdOn];

  const Subject({
    required this.id,
    required super.design,
    required super.name,
    required super.abbreviation,
    required super.connectedCourses,
    super.createdOn,
  });
}

class SubjectInput extends Equatable {
  final Design design;
  final String name;
  final String abbreviation;
  final IList<ConnectedCourse> connectedCourses;
  final DateTime? createdOn;

  @override
  List<Object?> get props =>
      [design, name, abbreviation, connectedCourses, createdOn];

  const SubjectInput({
    required this.design,
    required this.name,
    required this.abbreviation,
    required this.connectedCourses,
    this.createdOn,
  });
}

extension on SubjectInput {
  Subject toSubject(SubjectId id) {
    return Subject(
      id: id,
      design: design,
      name: name,
      abbreviation: abbreviation,
      connectedCourses: connectedCourses,
      createdOn: createdOn,
    );
  }
}

class ConnectedCourse extends Equatable {
  final CourseId id;
  final String name;
  final String abbreviation;
  final String subjectName;
  final DateTime? addedOn;

  @override
  List<Object?> get props => [id, name, abbreviation, subjectName, addedOn];

  const ConnectedCourse({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.subjectName,
    this.addedOn,
  });
}

class Weight extends Equatable {
  final num asFactor;
  num get asPercentage => asFactor * 100;
  @override
  List<Object?> get props => [asFactor];

  const Weight.percent(num percent) : asFactor = percent / 100;
  const Weight.factor(this.asFactor);
  static const zero = Weight.factor(0);

  @override
  String toString() {
    return 'Weight($asFactor / $asPercentage%)';
  }
}
