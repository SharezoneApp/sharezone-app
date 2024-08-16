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

part 'src/grades_service_internal.dart';
part 'src/grades_repository.dart';
part 'src/grading_systems.dart';
part 'src/term.dart';

class GradesService {
  rx.BehaviorSubject<IList<TermResult>> get terms => _service.terms;
  final _GradesServiceInternal _service;

  GradesService({GradesStateRepository? repository})
      : _service = _GradesServiceInternal(repository: repository);

  TermRef addTerm({
    required String name,
    required GradeTypeId finalGradeType,
    required GradingSystem gradingSystem,
    required bool isActiveTerm,
    @visibleForTesting TermId? id,
  }) {
    final newId = _service.addTerm(
      id: id ?? TermId(Id.generate().value),
      name: name,
      finalGradeType: finalGradeType,
      gradingSystem: gradingSystem,
      isActiveTerm: isActiveTerm,
    );

    return term(newId);
  }

  TermRef term(TermId id) {
    return TermRef._(id, _service);
  }

  GradeRef grade(GradeId id) {
    final term = _service._terms.firstWhereOrNull((term) => term.hasGrade(id));
    if (term == null) {
      throw GradeNotFoundException(id);
    }
    final subject =
        term.subjects.firstWhereOrNull((subject) => subject.hasGrade(id));

    return this.term(term.id).subject(subject!.id).grade(id);
  }

  /// Returns the possible grades for the given grading system as strings.
  ///
  /// The strings are ordered from the best grade to the worst grade.
  ///
  /// For example the values for the grading system "1-6 with plus and minus"
  /// would be: `['1+', '1', '1-', '2+', [...] '5+', '5', '5-', '6']`
  PossibleGradesResult getPossibleGrades(GradingSystem gradingSystem) {
    return _service.getPossibleGrades(gradingSystem);
  }

  IList<GradeType> getPossibleGradeTypes() {
    return _service.getPossibleGradeTypes();
  }

  /// Creates a custom grade type.
  ///
  /// If the grade type already exists, nothing will happen.
  GradeTypeId addCustomGradeType({
    required String displayName,
    @visibleForTesting GradeTypeId? id,
  }) {
    return _service.addCustomGradeType(displayName: displayName, id: id);
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
    _service.editCustomGradeType(id: id, displayName: displayName);
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
    _service.deleteCustomGradeType(id);
  }

  SubjectId addSubject(SubjectInput subjectInput,
      {@visibleForTesting SubjectId? id}) {
    return _service.addSubject(subjectInput, id: id);
  }

  IList<Subject> getSubjects() {
    return _service.getSubjects();
  }

  Subject? getSubject(SubjectId id) {
    return _service.getSubject(id);
  }
}

class TermRef {
  final TermId id;

  final _GradesServiceInternal _service;

  TermRef._(this.id, this._service);

  TermSubjectRef subject(SubjectId id) {
    return TermSubjectRef._(id, this, _service);
  }

  void changeFinalGradeType(GradeTypeId gradeType) {
    _service.editTerm(id: id, finalGradeType: gradeType);
  }

  void changeGradingSystem(GradingSystem gradingSystem) {
    _service.editTerm(id: id, gradingSystem: gradingSystem);
  }

  void changeName(String name) {
    _service.editTerm(id: id, name: name);
  }

  void changeActiveTerm(bool isActiveTerm) {
    _service.editTerm(id: id, isActiveTerm: isActiveTerm);
  }

  void delete() {
    _service.deleteTerm(id);
  }

  void changeGradeTypeWeight(GradeTypeId gradeType, Weight weight) {
    _service.changeGradeTypeWeightForTerm(
        termId: id, gradeType: gradeType, weight: weight);
  }

  void removeGradeTypeWeight(GradeTypeId gradeType) {
    _service.removeGradeTypeWeightForTerm(termId: id, gradeType: gradeType);
  }

  void changeWeightDisplayType(WeightDisplayType weightDisplayType) {
    _service.changeWeightDisplayTypeForTerm(
        termId: id, weightDisplayType: weightDisplayType);
  }
}

class TermSubjectRef {
  final SubjectId id;
  final TermRef termRef;
  final _GradesServiceInternal _service;

  TermSubjectRef._(this.id, this.termRef, this._service);

  GradeRef grade(GradeId id) {
    return GradeRef._(id, termRef, this, _service);
  }

  GradeRef addGrade(GradeInput gradeInput, {@visibleForTesting GradeId? id}) {
    if (_service.getSubject(this.id) == null) {
      throw SubjectNotFoundException(this.id);
    }
    return grade(id ?? GradeId(Id.generate().value)).create(gradeInput);
  }

  void changeFinalGradeType(GradeTypeId? gradeType) {
    _service.changeSubjectFinalGradeType(
        id: id, termId: termRef.id, gradeType: gradeType);
  }

  void changeWeightType(WeightType perGradeType) {
    _service.changeSubjectWeightTypeSettings(
        id: id, termId: termRef.id, perGradeType: perGradeType);
  }

  void changeWeightForTermGrade(Weight weight) {
    _service.changeSubjectWeightForTermGrade(
        id: id, termId: termRef.id, weight: weight);
  }

  void changeGradeTypeWeight(GradeTypeId gradeType, Weight weight) {
    _service.changeGradeTypeWeightForSubject(
        id: id, termId: termRef.id, gradeType: gradeType, weight: weight);
  }

  void removeGradeTypeWeight(GradeTypeId gradeType) {
    _service.removeGradeTypeWeightForSubject(
        id: id, termId: termRef.id, gradeType: gradeType);
  }
}

class GradeRef {
  final GradeId id;
  final TermRef termRef;
  final TermSubjectRef subjectRef;
  final _GradesServiceInternal _service;

  GradeRef._(this.id, this.termRef, this.subjectRef, this._service);

  GradeRef create(GradeInput gradeInput) {
    _service.addGrade(
      id: id,
      subjectId: subjectRef.id,
      termId: termRef.id,
      value: gradeInput,
    );

    return this;
  }

  void changeWeight(Weight weight) {
    _service.changeGradeWeight(id: id, termId: termRef.id, weight: weight);
  }

  void edit(GradeInput newGrade) {
    _service.editGrade(id, newGrade);
  }

  void delete() {
    _service.deleteGrade(id);
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
  final WeightDisplayType weightDisplayType;

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
    required this.weightDisplayType,
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
        weightDisplayType,
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

enum WeightDisplayType {
  percent(dbKey: 'percent'),
  factor(dbKey: 'factor');

  const WeightDisplayType({required this.dbKey});
  final String dbKey;
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
