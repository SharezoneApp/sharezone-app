// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:rxdart/subjects.dart' as rx;
import 'package:sharezone/grades/models/grade_id.dart';
import '../models/subject_id.dart';
import '../models/term_id.dart';
import 'src/term.dart';

export '../models/grade_id.dart';
export '../models/subject_id.dart';
export '../models/term_id.dart';

class GradesService {
  final rx.BehaviorSubject<IList<TermResult>> terms;

  GradesService() : terms = rx.BehaviorSubject.seeded(const IListConst([]));

  IList<Term> _terms = const IListConst<Term>([]);

  void _updateTerm(Term term) {
    _terms = _terms.replaceAllWhere((t) => t.id == term.id, term);
    _updateTerms();
  }

  void _updateTerms() {
    final termRes = _terms.map((term) {
      return TermResult(
        id: term.id,
        name: term.name,
        isActiveTerm: term.isActiveTerm,
        calculatedGrade: term.tryGetTermGrade() != null
            ? CalculatedGradeResult(
                asDouble: term.tryGetTermGrade()!.toDouble(),
                closestGrade: 'TODO',
              )
            : null,
        subjects: term.subjects
            .map(
              (subject) => SubjectResult(
                id: subject.id,
                calculatedGrade: subject.gradeVal != null
                    ? CalculatedGradeResult(
                        asDouble: subject.gradeVal!.toDouble(),
                        // TODO: Not happy with this, idk I should access/call
                        // the grading system from here
                        closestGrade: subject.calculatedGrade!.gradingSystem
                            .getClosestGrade(subject.gradeVal!),
                      )
                    : null,
                weightType: subject.weightType,
                gradeTypeWeights: subject.gradeTypeWeights
                    .map((key, value) => MapEntry(key, Weight.factor(value))),
              ),
            )
            .toIList(),
      );
    }).toIList();
    terms.add(termRes);
  }

  void createTerm({
    required TermId id,
    required String name,
    required GradeType finalGradeType,
    required bool isActiveTerm,
  }) {
    if (isActiveTerm) {
      _terms = _terms.map((term) => term.setIsActiveTerm(false)).toIList();
    }

    _terms = _terms.add(
      Term(
        id: id,
        isActiveTerm: isActiveTerm,
        name: name,
        finalGradeType: finalGradeType,
      ),
    );
    _updateTerms();
  }

  Term _term(TermId id) => _terms.singleWhere((term) => term.id == id);

  void addSubject(
      {required SubjectId id,
      required TermId toTerm,
      // TODO: gradingSystem shouldn't be required as it should be inherited
      // from the term
      required GradingSystem gradingSystem}) {
    final newTerm = _term(toTerm).addSubject(Subject(id, gradingSystem));
    _updateTerm(newTerm);
  }

  void changeSubjectWeightForTermGrade(
      {required SubjectId id, required TermId termId, required Weight weight}) {
    final newTerm =
        _term(termId).subject(id).changeWeightingForTermGrade(weight.asFactor);

    _updateTerm(newTerm);
  }

  void changeSubjectWeightTypeSettings(
      {required SubjectId id,
      required TermId termId,
      required WeightType perGradeType}) {
    final newTerm = _term(termId).subject(id).changeWeightingType(perGradeType);
    _updateTerm(newTerm);
  }

  void changeGradeTypeWeightForSubject({
    required SubjectId id,
    required TermId termId,
    required GradeType gradeType,
    required Weight weight,
  }) {
    final newTerm = _term(termId).subject(id).changeGradeTypeWeighting(
        gradeType,
        weight: weight.asFactor.toDouble());
    _updateTerm(newTerm);
  }

  void addGrade({
    required SubjectId id,
    required TermId termId,
    required Grade value,
    bool takeIntoAccount = true,
  }) {
    final newTerm = _term(termId)
        .subject(id)
        .addGrade(value, takeIntoAccount: takeIntoAccount);
    _updateTerm(newTerm);
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
    final newTerm =
        subject.grade(id).changeWeight(weight: weight.asFactor.toDouble());

    _updateTerm(newTerm);
  }

  void changeGradeTypeWeightForTerm(
      {required TermId termId,
      required GradeType gradeType,
      required Weight weight}) {
    final newTerm = _term(termId).changeWeightingOfGradeType(gradeType,
        weight: weight.asFactor.toDouble());
    _updateTerm(newTerm);
  }

  void changeSubjectFinalGradeType({
    required SubjectId id,
    required TermId termId,
    required GradeType? gradeType,
  }) {
    if (gradeType == null) {
      final newTerm = _term(termId).subject(id).inheritFinalGradeTypeFromTerm();
      return _updateTerm(newTerm);
    }
    final newTerm = _term(termId).subject(id).changeFinalGradeType(gradeType);
    _updateTerm(newTerm);
  }
}

class SubjectResult {
  final SubjectId id;
  final CalculatedGradeResult? calculatedGrade;
  final WeightType weightType;
  final IMap<GradeType, Weight> gradeTypeWeights;

  SubjectResult({
    required this.id,
    required this.calculatedGrade,
    required this.weightType,
    required this.gradeTypeWeights,
  });
}

class TermResult {
  final TermId id;
  final CalculatedGradeResult? calculatedGrade;
  IList<SubjectResult> subjects;
  final bool isActiveTerm;
  final String name;

  SubjectResult subject(SubjectId id) {
    final subject = subjects.firstWhere((element) => element.id == id);
    return subject;
  }

  TermResult({
    required this.id,
    required this.name,
    required this.calculatedGrade,
    required this.subjects,
    required this.isActiveTerm,
  });
}

class CalculatedGradeResult {
  final double asDouble;
  final String closestGrade;

  CalculatedGradeResult({
    required this.asDouble,
    required this.closestGrade,
  });
}

sealed class GradingSystem {
  static final oneToSixWithPlusAndMinus = OneToSixWithPlusMinusGradingSystem();
  static final oneToFiveteenPoints = OneToFiveteenPointsGradingSystem();

  String getClosestGrade(num grade);

  double toDoubleOrThrow(String grade);
}

class OneToFiveteenPointsGradingSystem extends GradingSystem
    with EquatableMixin {
  @override
  String getClosestGrade(num grade) {
    // TODO: Rounds up on .5, should round down (fix it with a test case for it)
    return grade.round().toString();
  }

  @override
  double toDoubleOrThrow(String grade) {
    return double.parse(grade);
  }

  @override
  List<Object?> get props => [];
}

class OneToSixWithPlusMinusGradingSystem extends GradingSystem
    with EquatableMixin {
  final Map<String, num> _gradeToNum = {
    '1+': 0.75,
    '1': 1,
    '1-': 1.25,
    '2+': 1.75,
    '2': 2,
    '2-': 2.25,
    '3+': 2.75,
    '3': 3,
    '3-': 3.25,
    '4+': 3.75,
    '4': 4,
    '4-': 4.25,
    '5+': 4.75,
    '5': 5,
    '5-': 5.25,
    '6': 6,
  };

  final Map<num, String> _numToGrade = {
    0.75: '1+',
    1: '1',
    1.25: '1-',
    1.75: '2+',
    2: '2',
    2.25: '2-',
    2.75: '3+',
    3: '3',
    3.25: '3-',
    3.75: '4+',
    4: '4',
    4.25: '4-',
    4.75: '5+',
    5: '5',
    5.25: '5-',
    6: '6',
  };

  @override
  String getClosestGrade(num grade) {
    final grades = _gradeToNum.values.toList();
    final closest = grades.reduce((a, b) {
      return (a - grade).abs() < (b - grade).abs() ? a : b;
    });
    return _numToGrade[closest]!;
  }

  @override
  double toDoubleOrThrow(String grade) {
    return switch (grade) {
      '1+' => 0.75,
      '1' => 1,
      '1-' => 1.25,
      '2+' => 1.75,
      '2' => 2,
      '2-' => 2.25,
      '3+' => 2.75,
      '3' => 3,
      '3-' => 3.25,
      '4+' => 3.75,
      '4' => 4,
      '4-' => 4.25,
      '5+' => 4.75,
      '5' => 5,
      '5-' => 5.25,
      '6' => 6,
      _ => throw ArgumentError.value(
          grade,
          'grade',
          'Invalid grade value',
        ),
    };
  }

  @override
  List<Object?> get props => [];
}

class Grade {
  final GradeId id;
  final num value;
  final GradingSystem gradingSystem;
  final GradeType type;

  Grade({
    required this.id,
    required this.value,
    required this.gradingSystem,
    // TODO: Make it required?
    this.type = const GradeType('testGradeType'),
  });
}

enum WeightType { perGrade, perGradeType, inheritFromTerm }

class GradeType extends Equatable {
  final String id;

  @override
  List<Object?> get props => [id];

  const GradeType(this.id);
}

class Subject {
  final SubjectId id;
  final GradingSystem gradingSystem;

  Subject(this.id, this.gradingSystem);
}

class Weight extends Equatable {
  final num asFactor;
  num get asPercentage => asFactor * 100;
  @override
  List<Object?> get props => [asFactor];

  const Weight.percent(num percent) : asFactor = percent / 100;
  const Weight.factor(this.asFactor);

  @override
  String toString() {
    return 'Weight($asFactor / $asPercentage%)';
  }
}
