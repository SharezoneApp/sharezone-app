// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../grades_service.dart';

class Term {
  final TermId id;
  final IList<_Subject> _subjects;
  final IMap<GradeType, double> _gradeTypeWeightings;
  final GradingSystem gradingSystem;
  final GradeType finalGradeType;
  final bool isActiveTerm;
  final String name;

  IList<_Subject> get subjects {
    return _subjects;
  }

  Term({
    required this.id,
    required this.finalGradeType,
    required this.gradingSystem,
    required this.isActiveTerm,
    required this.name,
  })  : _subjects = const IListConst([]),
        _gradeTypeWeightings = const IMapConst({});

  Term.internal(
    this.id,
    this._subjects,
    this._gradeTypeWeightings,
    this.finalGradeType,
    this.isActiveTerm,
    this.name,
    this.gradingSystem,
  );

  Term addSubject(Subject subject) {
    return _copyWith(
      subjects: _subjects.add(_newSubject(subject.id)),
    );
  }

  _Subject _newSubject(SubjectId id) {
    return _Subject(
      term: this,
      id: id,
      gradingSystem: gradingSystem,
      finalGradeType: finalGradeType,
      weightType: WeightType.inheritFromTerm,
      gradeTypeWeightingsFromTerm: _gradeTypeWeightings,
    );
  }

  _Subject subject(SubjectId id) {
    return _subjects.where((s) => s.id == id).first;
  }

  Term _copyWith({
    TermId? id,
    IList<_Subject>? subjects,
    IMap<GradeType, double>? gradeTypeWeightings,
    GradeType? finalGradeType,
    bool? isActiveTerm,
    String? name,
    GradingSystem? gradingSystem,
  }) {
    return Term.internal(
      id ?? this.id,
      subjects ?? _subjects,
      gradeTypeWeightings ?? _gradeTypeWeightings,
      finalGradeType ?? this.finalGradeType,
      isActiveTerm ?? this.isActiveTerm,
      name ?? this.name,
      gradingSystem ?? this.gradingSystem,
    );
  }

  num? tryGetTermGrade() {
    try {
      return getTermGrade();
    } catch (e) {
      return null;
    }
  }

  num getTermGrade() {
    final gradedSubjects =
        _subjects.where((element) => element.gradeVal != null);
    return gradedSubjects
            .map((subject) => subject.gradeVal! * subject.weightingForTermGrade)
            .reduce(
              (a, b) => a + b,
            ) /
        gradedSubjects
            .map((e) => e.weightingForTermGrade)
            .reduce((a, b) => a + b);
  }

  Term changeWeightTypeForSubject(SubjectId id, WeightType weightType) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      weightType: weightType,
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  Term changeWeightingOfGradeType(GradeType type, {required num weight}) {
    final newWeights = _gradeTypeWeightings.add(type, weight.toDouble());
    final newSubjects = _subjects.map((s) {
      final newSubject = s.copyWith(gradeTypeWeightingsFromTerm: newWeights);
      return newSubject;
    }).toIList();

    return _copyWith(subjects: newSubjects, gradeTypeWeightings: newWeights);
  }

  Term setFinalGradeType(GradeType gradeType) {
    final newSubjects =
        _subjects.where((s) => s.isFinalGradeTypeOverridden == false).map((s) {
      final newSubject = s.copyWith(finalGradeType: gradeType);
      return newSubject;
    }).toIList();

    return _copyWith(finalGradeType: gradeType, subjects: newSubjects);
  }

  Term addGrade(Grade grade,
      {required SubjectId toSubject, bool takenIntoAccount = true}) {
    var subject = _subjects.firstWhere(
      (s) => s.id == toSubject,
      orElse: () => _newSubject(toSubject),
    );

    final gradingSystem = grade.gradingSystem.toGradingSystem();
    final gradeVal = _getGradeDouble(grade.value, gradingSystem);

    subject = subject._addGrade(_Grade(
      term: this,
      id: grade.id,
      value: gradeVal,
      gradingSystem: gradingSystem,
      takenIntoAccount: takenIntoAccount,
      gradeType: grade.type,
      weight: 1,
    ));

    return _subjects.where((element) => element.id == toSubject).isNotEmpty
        ? _copyWith(
            subjects: _subjects.replaceAllWhere(
                (element) => element.id == toSubject, subject))
        : _copyWith(subjects: _subjects.add(subject));
  }

  double _getGradeDouble(Object grade, GradingSystem gradingSystem) {
    if (grade is double) return grade;
    if (grade is int) return grade.toDouble();
    if (grade is String) return gradingSystem.toDoubleOrThrow(grade);
    throw Exception(
        'Grade must be a double, int or string, but was ${grade.runtimeType}: $grade');
  }

  Term changeWeighting(SubjectId id, num newWeight) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      weightingForTermGrade: newWeight,
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  Term changeWeightingOfGradeTypeInSubject(
      SubjectId id, GradeType gradeType, double weight) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject =
        subject._changeGradeTypeWeight(gradeType, weight: weight);

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  Term changeWeightOfGrade(GradeId id, SubjectId subjectId, double weight) {
    final subject = _subjects.firstWhere((s) => s.id == subjectId);
    final newSubject = subject.copyWith(
      grades: subject.grades.replaceFirstWhere(
        (g) => g.id == id,
        (g) => g!._changeWeight(weight),
      ),
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == subjectId, newSubject),
    );
  }

  Term setFinalGradeTypeForSubject(SubjectId id, GradeType gradeType) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject._overrideFinalGradeType(gradeType);

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  Term subjectInheritFinalGradeTypeFromTerm(SubjectId id) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      finalGradeType: finalGradeType,
      isFinalGradeTypeOverridden: false,
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  Term setIsActiveTerm(bool isActiveTerm) {
    return _copyWith(isActiveTerm: isActiveTerm);
  }
}

class CalculatedGradeRes {
  final double asDouble;
  final GradingSystem gradingSystem;

  CalculatedGradeRes({
    required this.asDouble,
    required this.gradingSystem,
  });
}

class _Subject {
  final Term term;
  final SubjectId id;
  final GradingSystem gradingSystem;
  final IList<_Grade> grades;
  final GradeType finalGradeType;
  final bool isFinalGradeTypeOverridden;
  final num weightingForTermGrade;
  final IMap<GradeType, double> gradeTypeWeightings;
  final IMap<GradeType, double> gradeTypeWeightingsFromTerm;
  final WeightType weightType;

  late final num? gradeVal;

  _Subject({
    required this.term,
    required this.id,
    required this.weightType,
    required this.gradingSystem,
    required this.finalGradeType,
    this.isFinalGradeTypeOverridden = false,
    this.grades = const IListConst([]),
    this.weightingForTermGrade = 1,
    this.gradeTypeWeightings = const IMapConst({}),
    this.gradeTypeWeightingsFromTerm = const IMapConst({}),
  }) {
    gradeVal = _getGradeVal();
  }

  num? _getGradeVal() {
    final grds = grades.where((grade) =>
        grade.takenIntoAccount && grade.gradingSystem == gradingSystem);
    if (grds.isEmpty) return null;

    final finalGrade =
        grds.where((grade) => grade.gradeType == finalGradeType).firstOrNull;
    if (finalGrade != null) return finalGrade.value;

    return grds
            .map((grade) => grade.value * _weightFor(grade))
            .reduce((a, b) => a + b) /
        grds.map((e) => _weightFor(e)).reduce((a, b) => a + b);
  }

  _Subject _addGrade(_Grade grade) {
    return copyWith(grades: grades.add(grade));
  }

  num _weightFor(_Grade grade) {
    return switch (weightType) {
      WeightType.perGrade => grade.weight,
      WeightType.perGradeType => gradeTypeWeightings[grade.gradeType] ?? 1,
      WeightType.inheritFromTerm =>
        gradeTypeWeightingsFromTerm[grade.gradeType] ?? 1,
    };
  }

  _Subject _changeGradeTypeWeight(GradeType gradeType,
      {required double weight}) {
    return copyWith(
        gradeTypeWeightings: gradeTypeWeightings.add(gradeType, weight));
  }

  _Subject _overrideFinalGradeType(GradeType gradeType) {
    return copyWith(
        finalGradeType: gradeType, isFinalGradeTypeOverridden: true);
  }

  _Grade grade(GradeId id) {
    return grades.firstWhere((element) => element.id == id);
  }

  _Subject copyWith({
    Term? term,
    SubjectId? id,
    IList<_Grade>? grades,
    GradeType? finalGradeType,
    bool? isFinalGradeTypeOverridden,
    num? weightingForTermGrade,
    GradingSystem? gradingSystem,
    IMap<GradeType, double>? gradeTypeWeightings,
    IMap<GradeType, double>? gradeTypeWeightingsFromTerm,
    WeightType? weightType,
  }) {
    return _Subject(
      term: term ?? this.term,
      id: id ?? this.id,
      grades: grades ?? this.grades,
      gradingSystem: gradingSystem ?? this.gradingSystem,
      finalGradeType: finalGradeType ?? this.finalGradeType,
      isFinalGradeTypeOverridden:
          isFinalGradeTypeOverridden ?? this.isFinalGradeTypeOverridden,
      weightingForTermGrade:
          weightingForTermGrade ?? this.weightingForTermGrade,
      gradeTypeWeightings: gradeTypeWeightings ?? this.gradeTypeWeightings,
      weightType: weightType ?? this.weightType,
      gradeTypeWeightingsFromTerm:
          gradeTypeWeightingsFromTerm ?? this.gradeTypeWeightingsFromTerm,
    );
  }
}

class _Grade extends Equatable {
  final Term term;
  final GradeId id;
  final num value;
  final GradingSystem gradingSystem;
  final GradeType gradeType;
  final bool takenIntoAccount;
  final num weight;

  @override
  List<Object?> get props =>
      [id, value, gradingSystem, gradeType, takenIntoAccount, weight];

  const _Grade({
    required this.term,
    required this.id,
    required this.value,
    required this.gradeType,
    required this.gradingSystem,
    required this.weight,
    // TODO: Make required?
    this.takenIntoAccount = true,
  });

  _Grade _changeWeight(double weight) {
    return copyWith(weight: weight, takenIntoAccount: weight > 0);
  }

  _Grade copyWith({
    Term? term,
    GradeId? id,
    num? value,
    GradingSystem? gradingSystem,
    GradeType? gradeType,
    bool? takenIntoAccount,
    num? weight,
  }) {
    return _Grade(
      term: term ?? this.term,
      id: id ?? this.id,
      value: value ?? this.value,
      gradingSystem: gradingSystem ?? this.gradingSystem,
      gradeType: gradeType ?? this.gradeType,
      takenIntoAccount: takenIntoAccount ?? this.takenIntoAccount,
      weight: weight ?? this.weight,
    );
  }
}
