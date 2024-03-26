// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
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
        gradingSystem: term.gradingSystem.toGradingSystems(),
        calculatedGrade: term.tryGetTermGrade() != null
            ? CalculatedGradeResult(
                asDouble: term.tryGetTermGrade()!.toDouble(),
              )
            : null,
        subjects: term.subjects
            .map(
              (subject) => SubjectResult(
                id: subject.id,
                calculatedGrade: subject.gradeVal != null
                    ? CalculatedGradeResult(
                        asDouble: subject.gradeVal!.toDouble(),
                      )
                    : null,
                weightType: subject.weightType,
                gradeTypeWeights: subject.gradeTypeWeightings
                    .map((key, value) => MapEntry(key, Weight.factor(value))),
                grades: subject.grades
                    .map(
                      (grade) => GradeResult(
                        id: grade.id,
                        isTakenIntoAccount: grade.takenIntoAccount,
                        doubleValue: grade.value.toDouble(),
                      ),
                    )
                    .toIList(),
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
    required GradeTypeId finalGradeType,
    required GradingSystems gradingSystem,
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
        gradingSystem: gradingSystem.toGradingSystem(),
      ),
    );
    _updateTerms();
  }

  Term _term(TermId id) => _terms.singleWhere((term) => term.id == id);

  void addSubject({
    required SubjectId id,
    required TermId toTerm,
  }) {
    final newTerm = _term(toTerm).addSubject(Subject(id));
    _updateTerm(newTerm);
  }

  void changeSubjectWeightForTermGrade(
      {required SubjectId id, required TermId termId, required Weight weight}) {
    final newTerm =
        _term(termId).changeWeighting(id, weight.asFactor.toDouble());

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
    final newTerm = _term(termId).changeWeightingOfGradeTypeInSubject(
        id, gradeType, weight.asFactor.toDouble());
    _updateTerm(newTerm);
  }

  void addGrade({
    required SubjectId id,
    required TermId termId,
    required Grade value,
    bool takeIntoAccount = true,
  }) {
    final newTerm = _term(termId)
        .addGrade(value, toSubject: id, takenIntoAccount: takeIntoAccount);
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
    final newTerm = _term(termId)
        .changeWeightOfGrade(id, subject.id, weight.asFactor.toDouble());

    _updateTerm(newTerm);
  }

  void changeGradeTypeWeightForTerm(
      {required TermId termId,
      required GradeTypeId gradeType,
      required Weight weight}) {
    final newTerm = _term(termId).changeWeightingOfGradeType(gradeType,
        weight: weight.asFactor.toDouble());
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
  List<String> getPossibleGrades(GradingSystems gradingSystem) {
    final gs = gradingSystem.toGradingSystem();
    return gs.possibleValues;
  }

  IList<GradeType> getPossibleGradeTypes() {
    return GradeType.predefinedGradeTypes;
  }
}

enum GradingSystems { oneToSixWithPlusAndMinus, oneToFiveteenPoints }

extension ToGradingSystem on GradingSystems {
  GradingSystem toGradingSystem() {
    switch (this) {
      case GradingSystems.oneToFiveteenPoints:
        return GradingSystem.oneToFiveteenPoints;
      case GradingSystems.oneToSixWithPlusAndMinus:
        return GradingSystem.oneToSixWithPlusAndMinus;
    }
  }
}

extension ToGradingSystems on GradingSystem {
  GradingSystems toGradingSystems() {
    if (this is OneToFiveteenPointsGradingSystem) {
      return GradingSystems.oneToFiveteenPoints;
    } else if (this is OneToSixWithPlusMinusGradingSystem) {
      return GradingSystems.oneToSixWithPlusAndMinus;
    }
    throw UnimplementedError();
  }
}

enum PredefinedGradeTypes {
  schoolReportGrade,
  writtenExam,
  oralParticipation,
  vocabularyTest,
  presentation,
  other,
}

class GradeType {
  final GradeTypeId id;
  final PredefinedGradeTypes? predefinedType;

  const GradeType({required this.id, this.predefinedType});

  static const predefinedGradeTypes = IListConst([
    GradeType.schoolReportGrade(),
    GradeType.writtenExam(),
    GradeType.oralParticipation(),
    GradeType.vocabularyTest(),
    GradeType.presentation(),
    GradeType.other(),
  ]);
  const GradeType.schoolReportGrade()
      : id = const GradeTypeId('school-report-grade'),
        predefinedType = PredefinedGradeTypes.schoolReportGrade;
  const GradeType.writtenExam()
      : id = const GradeTypeId('written-exam'),
        predefinedType = PredefinedGradeTypes.writtenExam;
  const GradeType.oralParticipation()
      : id = const GradeTypeId('oral-participation'),
        predefinedType = PredefinedGradeTypes.oralParticipation;
  const GradeType.vocabularyTest()
      : id = const GradeTypeId('vocabulary-test'),
        predefinedType = PredefinedGradeTypes.vocabularyTest;
  const GradeType.presentation()
      : id = const GradeTypeId('presentation'),
        predefinedType = PredefinedGradeTypes.presentation;
  const GradeType.other()
      : id = const GradeTypeId('other'),
        predefinedType = PredefinedGradeTypes.other;
}

class GradeResult {
  final GradeId id;
  final double doubleValue;
  final bool isTakenIntoAccount;

  GradeResult({
    required this.id,
    required this.isTakenIntoAccount,
    required this.doubleValue,
  });
}

class SubjectResult {
  final SubjectId id;
  final CalculatedGradeResult? calculatedGrade;
  final WeightType weightType;
  final IMap<GradeTypeId, Weight> gradeTypeWeights;
  final IList<GradeResult> grades;

  SubjectResult({
    required this.id,
    required this.calculatedGrade,
    required this.weightType,
    required this.gradeTypeWeights,
    required this.grades,
  });

  GradeResult grade(GradeId gradeId) {
    return grades.firstWhere((element) => element.id == gradeId);
  }
}

class TermResult {
  final TermId id;
  final GradingSystems gradingSystem;
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
    required this.gradingSystem,
    required this.name,
    required this.calculatedGrade,
    required this.subjects,
    required this.isActiveTerm,
  });
}

class CalculatedGradeResult {
  final double asDouble;

  String get displayableGrade =>
      asDouble.toStringAsFixed(2).replaceAll('.', ',').substring(0, 3);

  CalculatedGradeResult({required this.asDouble});
}

sealed class GradingSystem {
  static final oneToSixWithPlusAndMinus = OneToSixWithPlusMinusGradingSystem();
  static final oneToFiveteenPoints = OneToFiveteenPointsGradingSystem();

  double toDoubleOrThrow(String grade);
  List<String> get possibleValues;
}

class OneToFiveteenPointsGradingSystem extends GradingSystem
    with EquatableMixin {
  @override
  List<String> get possibleValues => [
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '10',
        '11',
        '12',
        '13',
        '14',
        '15',
      ];

  @override
  double toDoubleOrThrow(String grade) {
    return double.parse(grade);
  }

  @override
  List<Object?> get props => [];
}

class OneToSixWithPlusMinusGradingSystem extends GradingSystem
    with EquatableMixin {
  @override
  List<String> get possibleValues => [
        '1+',
        '1',
        '1-',
        '2+',
        '2',
        '2-',
        '3+',
        '3',
        '3-',
        '4+',
        '4',
        '4-',
        '5+',
        '5',
        '5-',
        '6',
      ];

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

  /// Either a number or a string like '1+', '2-', etc.
  final Object value;
  final GradingSystems gradingSystem;
  final GradeTypeId type;

  Grade({
    required this.id,
    required this.value,
    required this.gradingSystem,
    required this.type,
  });
}

enum WeightType { perGrade, perGradeType, inheritFromTerm }

class GradeTypeId extends Id {
  const GradeTypeId(super.id);
}

class Subject {
  final SubjectId id;

  Subject(this.id);
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
