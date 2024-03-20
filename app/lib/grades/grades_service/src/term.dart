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
  final GradeType finalGradeType;
  final bool isActiveTerm;
  final String name;

  IList<SubjectRes> get subjects {
    return _subjects.map(_toResult).toIList();
  }

  Term({
    required this.id,
    required this.finalGradeType,
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
  );

  Term addSubject(Subject subject) {
    return _copyWith(
      subjects: _subjects.add(_newSubject(subject.id)),
    );
  }

  _Subject _newSubject(SubjectId id) {
    return _Subject(
      id: id,
      finalGradeType: finalGradeType,
      weightType: WeightType.inheritFromTerm,
      gradeTypeWeightingsFromTerm: _gradeTypeWeightings,
    );
  }

  SubjectRes _toResult(_Subject subject) => SubjectRes(
        this,
        gradeTypeWeights: subject.gradeTypeWeightings,
        grades: subject.grades
            .map(
              (grade) => GradeRes(
                this,
                id: grade.id,
                subjectId: subject.id,
                value: grade.value,
                type: grade.gradeType,
              ),
            )
            .toIList(),
        id: subject.id,
        gradeVal: subject.getGrade(),
        weightType: subject.weightType,
      );

  SubjectRes subject(SubjectId id) {
    return _subjects.where((s) => s.id == id).map(_toResult).first;
  }

  Term _copyWith({
    TermId? id,
    IList<_Subject>? subjects,
    IMap<GradeType, double>? gradeTypeWeightings,
    GradeType? finalGradeType,
    bool? isActiveTerm,
    String? name,
  }) {
    return Term.internal(
      id ?? this.id,
      subjects ?? _subjects,
      gradeTypeWeightings ?? _gradeTypeWeightings,
      finalGradeType ?? this.finalGradeType,
      isActiveTerm ?? this.isActiveTerm,
      name ?? this.name,
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
        _subjects.where((element) => element.getGrade() != null);
    return gradedSubjects
            .map((subject) =>
                subject.getGrade()! * subject.weightingForTermGrade)
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

  Term _addGrade(Grade grade,
      {required SubjectId toSubject, bool takenIntoAccount = true}) {
    var subject = _subjects.firstWhere(
      (s) => s.id == toSubject,
      orElse: () => _newSubject(toSubject),
    );
    subject = subject.addGrade(_Grade(
      id: grade.id,
      value: grade.value,
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

  Term _changeWeighting(SubjectId id, num newWeight) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      weightingForTermGrade: newWeight,
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  Term _changeWeightingOfGradeTypeInSubject(
      SubjectId id, GradeType gradeType, double weight) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.changeGradeTypeWeight(gradeType, weight: weight);

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  Term _changeWeightOfGrade(GradeId id, SubjectId subjectId, double weight) {
    final subject = _subjects.firstWhere((s) => s.id == subjectId);
    final newSubject = subject.copyWith(
      grades: subject.grades.replaceFirstWhere(
        (g) => g.id == id,
        (g) => g!.copyWith(weight: weight),
      ),
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == subjectId, newSubject),
    );
  }

  Term _setFinalGradeTypeForSubject(SubjectId id, GradeType gradeType) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.overrideFinalGradeType(gradeType);

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  Term _subjectInheritFinalGradeTypeFromTerm(SubjectId id) {
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

class SubjectRes {
  final Term _term;
  final SubjectId id;
  final num? gradeVal;
  final WeightType weightType;
  final IMap<GradeType, double> gradeTypeWeights;
  final IList<GradeRes> grades;

  SubjectRes(
    this._term, {
    required this.grades,
    required this.id,
    required this.gradeVal,
    required this.weightType,
    required this.gradeTypeWeights,
  });

  Term addGrade(Grade grade, {bool takeIntoAccount = true}) {
    return _term._addGrade(grade,
        toSubject: id, takenIntoAccount: takeIntoAccount);
  }

  Term changeWeightingForTermGrade(num newWeight) {
    return _term._changeWeighting(id, newWeight);
  }

  Term changeGradeTypeWeighting(GradeType gradeType, {required double weight}) {
    return _term._changeWeightingOfGradeTypeInSubject(id, gradeType, weight);
  }

  GradeRes grade(GradeId id) {
    return grades.firstWhere((element) => element.id == id);
  }

  Term changeWeightingType(WeightType weightType) {
    return _term.changeWeightTypeForSubject(id, weightType);
  }

  Term changeFinalGradeType(GradeType gradeType) {
    return _term._setFinalGradeTypeForSubject(id, gradeType);
  }

  Term inheritFinalGradeTypeFromTerm() {
    return _term._subjectInheritFinalGradeTypeFromTerm(id);
  }
}

class GradeRes {
  final Term _term;
  final GradeId id;
  final num value;
  final GradeType type;
  final SubjectId subjectId;

  GradeRes(
    this._term, {
    required this.id,
    required this.subjectId,
    required this.value,
    required this.type,
  });

  Term changeWeight({required double weight}) {
    return _term._changeWeightOfGrade(id, subjectId, weight);
  }
}

class _Subject {
  final SubjectId id;
  final IList<_Grade> grades;
  final GradeType finalGradeType;
  final bool isFinalGradeTypeOverridden;
  final num weightingForTermGrade;
  final IMap<GradeType, double> gradeTypeWeightings;
  final IMap<GradeType, double> gradeTypeWeightingsFromTerm;
  final WeightType weightType;

  _Subject({
    required this.id,
    required this.weightType,
    required this.finalGradeType,
    this.isFinalGradeTypeOverridden = false,
    this.grades = const IListConst([]),
    this.weightingForTermGrade = 1,
    this.gradeTypeWeightings = const IMapConst({}),
    this.gradeTypeWeightingsFromTerm = const IMapConst({}),
  });

  _Subject addGrade(_Grade grade) {
    return copyWith(grades: grades.add(grade));
  }

  num? getGrade() {
    final grds = grades.where((grade) => grade.takenIntoAccount);
    if (grds.isEmpty) return null;

    final finalGrade =
        grds.where((grade) => grade.gradeType == finalGradeType).firstOrNull;
    if (finalGrade != null) return finalGrade.value;

    return grds
            .map((grade) => grade.value * _weightFor(grade))
            .reduce((a, b) => a + b) /
        grds.map((e) => _weightFor(e)).reduce((a, b) => a + b);
  }

  num _weightFor(_Grade grade) {
    return switch (weightType) {
      WeightType.perGrade => grade.weight,
      WeightType.perGradeType => gradeTypeWeightings[grade.gradeType] ?? 1,
      WeightType.inheritFromTerm =>
        gradeTypeWeightingsFromTerm[grade.gradeType] ?? 1,
    };
  }

  _Subject changeGradeTypeWeight(GradeType gradeType,
      {required double weight}) {
    return copyWith(
        gradeTypeWeightings: gradeTypeWeightings.add(gradeType, weight));
  }

  _Subject overrideFinalGradeType(GradeType gradeType) {
    return copyWith(
        finalGradeType: gradeType, isFinalGradeTypeOverridden: true);
  }

  _Subject copyWith({
    SubjectId? id,
    IList<_Grade>? grades,
    GradeType? finalGradeType,
    bool? isFinalGradeTypeOverridden,
    num? weightingForTermGrade,
    IMap<GradeType, double>? gradeTypeWeightings,
    IMap<GradeType, double>? gradeTypeWeightingsFromTerm,
    WeightType? weightType,
  }) {
    return _Subject(
      id: id ?? this.id,
      grades: grades ?? this.grades,
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
  final GradeId id;
  final num value;
  final GradeType gradeType;
  final bool takenIntoAccount;
  final num weight;

  @override
  List<Object?> get props => [id, value, gradeType, takenIntoAccount, weight];

  const _Grade({
    required this.id,
    required this.value,
    required this.gradeType,
    required this.weight,
    this.takenIntoAccount = true,
  });

  _Grade copyWith({
    GradeId? id,
    num? value,
    GradeType? gradeType,
    bool? takenIntoAccount,
    num? weight,
  }) {
    return _Grade(
      id: id ?? this.id,
      value: value ?? this.value,
      gradeType: gradeType ?? this.gradeType,
      takenIntoAccount: takenIntoAccount ?? this.takenIntoAccount,
      weight: weight ?? this.weight,
    );
  }
}
