// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../grades_service.dart';

class _Term {
  final TermId id;
  final IList<_Subject> _subjects;
  final IMap<GradeTypeId, double> _gradeTypeWeightings;
  final _GradingSystem gradingSystem;
  final GradeTypeId finalGradeType;
  final bool isActiveTerm;
  final String name;

  IList<_Subject> get subjects {
    return _subjects;
  }

  _Term({
    required this.id,
    required this.finalGradeType,
    required this.gradingSystem,
    required this.isActiveTerm,
    required this.name,
  })  : _subjects = const IListConst([]),
        _gradeTypeWeightings = const IMapConst({});

  _Term.internal(
    this.id,
    this._subjects,
    this._gradeTypeWeightings,
    this.finalGradeType,
    this.isActiveTerm,
    this.name,
    this.gradingSystem,
  );

  bool hasSubject(SubjectId id) {
    return _subjects.any((s) => s.id == id);
  }

  _Term addSubject(Subject subject) {
    if (hasSubject(subject.id)) {
      throw SubjectAlreadyExistsException(subject.id);
    }
    return _copyWith(
      subjects: _subjects.add(_Subject(
        term: this,
        id: subject.id,
        name: subject.name,
        abbreviation: subject.abbreviation,
        design: subject.design,
        gradingSystem: gradingSystem,
        finalGradeType: finalGradeType,
        weightType: WeightType.inheritFromTerm,
        gradeTypeWeightingsFromTerm: _gradeTypeWeightings,
      )),
    );
  }

  _Subject subject(SubjectId id) {
    return _subjects.where((s) => s.id == id).first;
  }

  _Term _copyWith({
    TermId? id,
    IList<_Subject>? subjects,
    IMap<GradeTypeId, double>? gradeTypeWeightings,
    GradeTypeId? finalGradeType,
    bool? isActiveTerm,
    String? name,
    _GradingSystem? gradingSystem,
  }) {
    return _Term.internal(
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

  _Term changeWeightTypeForSubject(SubjectId id, WeightType weightType) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      weightType: weightType,
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  _Term changeWeightingOfGradeType(GradeTypeId type, {required num weight}) {
    final newWeights = _gradeTypeWeightings.add(type, weight.toDouble());
    final newSubjects = _subjects.map((s) {
      final newSubject = s.copyWith(gradeTypeWeightingsFromTerm: newWeights);
      return newSubject;
    }).toIList();

    return _copyWith(subjects: newSubjects, gradeTypeWeightings: newWeights);
  }

  _Term setFinalGradeType(GradeTypeId gradeType) {
    final newSubjects =
        _subjects.where((s) => s.isFinalGradeTypeOverridden == false).map((s) {
      final newSubject = s.copyWith(finalGradeType: gradeType);
      return newSubject;
    }).toIList();

    return _copyWith(finalGradeType: gradeType, subjects: newSubjects);
  }

  _Term addGrade(Grade grade, {required SubjectId toSubject}) {
    var subject = _subjects.firstWhere(
      (s) => s.id == toSubject,
      orElse: () => throw SubjectNotFoundException(toSubject),
    );

    final gradingSystem = grade.gradingSystem.toGradingSystem();
    final gradeVal = _toNumOrThrow(grade.value, gradingSystem);

    subject = subject._addGrade(_Grade(
      term: this,
      id: grade.id,
      date: grade.date,
      value: gradingSystem.toGradeResult(gradeVal),
      gradingSystem: gradingSystem,
      takenIntoAccount: grade.takeIntoAccount,
      gradeType: grade.type,
      weight: 1,
    ));

    return _subjects.where((element) => element.id == toSubject).isNotEmpty
        ? _copyWith(
            subjects: _subjects.replaceAllWhere(
                (element) => element.id == toSubject, subject))
        : _copyWith(subjects: _subjects.add(subject));
  }

  num _toNumOrThrow(Object grade, _GradingSystem gradingSystem) {
    if (grade is num) return grade;
    if (grade is String) {
      final possibleGrades = gradingSystem.possibleGrades;
      if (possibleGrades is NonNumericalPossibleGradesResult &&
          !possibleGrades.grades.contains(grade)) {
        throw InvalidGradeValueException(
          gradeInput: grade,
          gradingSystem: gradingSystem.toGradingSystems(),
        );
      }
      try {
        final db = gradingSystem.toNumOrThrow(grade);
        if (possibleGrades is ContinuousNumericalPossibleGradesResult) {
          if (db < possibleGrades.min || db > possibleGrades.max) {
            throw InvalidGradeValueException(
              gradeInput: grade.toString(),
              gradingSystem: gradingSystem.toGradingSystems(),
            );
          }
        }
        return db;
      } on InvalidGradeValueException {
        rethrow;
      } catch (e) {
        throw InvalidGradeValueException(
          gradeInput: grade,
          gradingSystem: gradingSystem.toGradingSystems(),
        );
      }
    }
    throw Exception(
        'Grade must be a double, int or string, but was ${grade.runtimeType}: $grade');
  }

  _Term changeWeighting(SubjectId id, num newWeight) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      weightingForTermGrade: newWeight,
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  _Term changeWeightingOfGradeTypeInSubject(
      SubjectId id, GradeTypeId gradeType, double weight) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject =
        subject._changeGradeTypeWeight(gradeType, weight: weight);

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  _Term changeWeightOfGrade(GradeId id, SubjectId subjectId, double weight) {
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

  _Term setFinalGradeTypeForSubject(SubjectId id, GradeTypeId gradeType) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject._overrideFinalGradeType(gradeType);

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  _Term subjectInheritFinalGradeTypeFromTerm(SubjectId id) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      finalGradeType: finalGradeType,
      isFinalGradeTypeOverridden: false,
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  _Term setIsActiveTerm(bool isActiveTerm) {
    return _copyWith(isActiveTerm: isActiveTerm);
  }
}

class _Subject {
  final _Term term;
  final SubjectId id;
  final String name;
  final _GradingSystem gradingSystem;
  final IList<_Grade> grades;
  final GradeTypeId finalGradeType;
  final bool isFinalGradeTypeOverridden;
  final num weightingForTermGrade;
  final IMap<GradeTypeId, double> gradeTypeWeightings;
  final IMap<GradeTypeId, double> gradeTypeWeightingsFromTerm;
  final WeightType weightType;
  final String abbreviation;
  final Design design;

  late final num? gradeVal;

  _Subject({
    required this.term,
    required this.id,
    required this.name,
    required this.weightType,
    required this.gradingSystem,
    required this.finalGradeType,
    required this.abbreviation,
    required this.design,
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
    if (finalGrade != null) return finalGrade.value.asNum;

    return grds
            .map((grade) => grade.value.asNum * _weightFor(grade))
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

  _Subject _changeGradeTypeWeight(GradeTypeId gradeType,
      {required double weight}) {
    return copyWith(
        gradeTypeWeightings: gradeTypeWeightings.add(gradeType, weight));
  }

  _Subject _overrideFinalGradeType(GradeTypeId gradeType) {
    return copyWith(
        finalGradeType: gradeType, isFinalGradeTypeOverridden: true);
  }

  _Grade grade(GradeId id) {
    return grades.firstWhere((element) => element.id == id);
  }

  _Subject copyWith({
    _Term? term,
    SubjectId? id,
    String? name,
    String? abbreviation,
    Design? design,
    IList<_Grade>? grades,
    GradeTypeId? finalGradeType,
    bool? isFinalGradeTypeOverridden,
    num? weightingForTermGrade,
    _GradingSystem? gradingSystem,
    IMap<GradeTypeId, double>? gradeTypeWeightings,
    IMap<GradeTypeId, double>? gradeTypeWeightingsFromTerm,
    WeightType? weightType,
  }) {
    return _Subject(
      term: term ?? this.term,
      id: id ?? this.id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      design: design ?? this.design,
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
  final _Term term;
  final GradeId id;
  final GradeValue value;
  final _GradingSystem gradingSystem;
  final GradeTypeId gradeType;
  final bool takenIntoAccount;
  final num weight;
  final Date date;

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
    required this.date,
    required this.takenIntoAccount,
  });

  _Grade _changeWeight(double weight) {
    return copyWith(weight: weight, takenIntoAccount: weight > 0);
  }

  _Grade copyWith({
    _Term? term,
    GradeId? id,
    GradeValue? value,
    Date? date,
    _GradingSystem? gradingSystem,
    GradeTypeId? gradeType,
    bool? takenIntoAccount,
    num? weight,
  }) {
    return _Grade(
      term: term ?? this.term,
      id: id ?? this.id,
      value: value ?? this.value,
      date: date ?? this.date,
      gradingSystem: gradingSystem ?? this.gradingSystem,
      gradeType: gradeType ?? this.gradeType,
      takenIntoAccount: takenIntoAccount ?? this.takenIntoAccount,
      weight: weight ?? this.weight,
    );
  }
}
