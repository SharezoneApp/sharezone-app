// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:rxdart/subjects.dart' as rx;
import 'package:sharezone/grades/models/grade_id.dart';
import '../models/subject_id.dart';
import '../models/term_id.dart';

export '../models/grade_id.dart';
export '../models/subject_id.dart';
export '../models/term_id.dart';

part 'src/term.dart';
part 'src/grading_systems.dart';

class GradesService {
  final rx.BehaviorSubject<IList<TermResult>> terms;

  GradesService() : terms = rx.BehaviorSubject.seeded(const IListConst([]));

  IList<_Term> _terms = const IListConst<_Term>([]);

  void _updateTerm(_Term term) {
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
            ? term.gradingSystem.toGradeResult(term.tryGetTermGrade()!)
            : null,
        subjects: term.subjects
            .map(
              (subject) => SubjectResult(
                id: subject.id,
                name: subject.name,
                design: subject.design,
                abbreviation: subject.abbreviation,
                calculatedGrade: subject.gradeVal != null
                    ? subject.gradingSystem.toGradeResult(subject.gradeVal!)
                    : null,
                weightType: subject.weightType,
                gradeTypeWeights: subject.gradeTypeWeightings
                    .map((key, value) => MapEntry(key, Weight.factor(value))),
                grades: subject.grades
                    .map(
                      (grade) => GradeResult(
                        id: grade.id,
                        date: grade.date,
                        isTakenIntoAccount: grade.takenIntoAccount,
                        value: grade.value,
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

  void addTerm({
    required TermId id,
    required String name,
    required GradeTypeId finalGradeType,
    required GradingSystem gradingSystem,
    required bool isActiveTerm,
  }) {
    if (isActiveTerm) {
      _terms = _terms.map((term) => term.setIsActiveTerm(false)).toIList();
    }

    _terms = _terms.add(
      _Term(
        id: id,
        isActiveTerm: isActiveTerm,
        name: name,
        finalGradeType: finalGradeType,
        gradingSystem: gradingSystem.toGradingSystem(),
      ),
    );
    _updateTerms();
  }

  _Term _term(TermId id) => _terms.singleWhere((term) => term.id == id);

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
  }) {
    final subject = _getSubjectOrThrow(id);
    if (!_hasGradeTypeWithId(value.type)) {
      throw GradeTypeNotFoundException(value.type);
    }

    var newTerm = _term(termId);
    if (!newTerm.hasSubject(id)) {
      newTerm = newTerm.addSubject(subject);
    }
    newTerm = newTerm.addGrade(value, toSubject: id);
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
  PossibleGradesResult getPossibleGrades(GradingSystem gradingSystem) {
    final gs = gradingSystem.toGradingSystem();
    return gs.possibleGrades;
  }

  IList<GradeType> getPossibleGradeTypes() {
    return GradeType.predefinedGradeTypes.addAll(_customGradeTypes);
  }

  var _customGradeTypes = IList<GradeType>();

  bool _hasGradeTypeWithId(GradeTypeId id) {
    return getPossibleGradeTypes().map((gt) => gt.id).contains(id);
  }

  /// Creates a custom grade type.
  ///
  /// If the grade type already exists, nothing will happen.
  void createCustomGradeType(GradeType gradeType) {
    if (_hasGradeTypeWithId(gradeType.id)) {
      // Already exists
      return;
    }
    _customGradeTypes = _customGradeTypes.add(gradeType);
  }

  var _subjects = IList<Subject>();

  void addSubject(Subject subject) {
    if (_subjects.any((s) => s.id == subject.id)) {
      throw SubjectAlreadyExistsException(subject.id);
    }
    _subjects = _subjects.add(subject);
  }

  IList<Subject> getSubjects() {
    return _subjects;
  }

  Subject? getSubject(SubjectId id) {
    return _subjects.firstWhereOrNull((subject) => subject.id == id);
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

enum GradingSystem {
  oneToSixWithPlusAndMinus(isNumericalAndContinous: true),
  zeroToFivteenPoints(isNumericalAndContinous: true),
  zeroToFivteenPointsWithDecimals(isNumericalAndContinous: true),
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

sealed class PossibleGradesResult {
  const PossibleGradesResult();
}

class NonNumericalPossibleGradesResult extends PossibleGradesResult {
  final IList<String> grades;

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
  other,
}

class GradeType extends Equatable {
  final GradeTypeId id;
  final PredefinedGradeTypes? predefinedType;

  @override
  List<Object?> get props => [id, predefinedType];

  const GradeType({required this.id, this.predefinedType});

  static const predefinedGradeTypes = IListConst([
    GradeType.schoolReportGrade,
    GradeType.writtenExam,
    GradeType.oralParticipation,
    GradeType.vocabularyTest,
    GradeType.presentation,
    GradeType.other,
  ]);
  static const schoolReportGrade = GradeType(
      id: GradeTypeId('school-report-grade'),
      predefinedType: PredefinedGradeTypes.schoolReportGrade);
  static const writtenExam = GradeType(
      id: GradeTypeId('written-exam'),
      predefinedType: PredefinedGradeTypes.writtenExam);
  static const oralParticipation = GradeType(
      id: GradeTypeId('oral-participation'),
      predefinedType: PredefinedGradeTypes.oralParticipation);
  static const vocabularyTest = GradeType(
      id: GradeTypeId('vocabulary-test'),
      predefinedType: PredefinedGradeTypes.vocabularyTest);
  static const presentation = GradeType(
      id: GradeTypeId('presentation'),
      predefinedType: PredefinedGradeTypes.presentation);
  static const other = GradeType(
      id: GradeTypeId('other'), predefinedType: PredefinedGradeTypes.other);
}

class GradeResult {
  final GradeId id;
  final GradeValue value;
  final bool isTakenIntoAccount;
  final Date date;
  GradingSystem get gradingSystem => value.gradingSystem;

  GradeResult({
    required this.id,
    required this.isTakenIntoAccount,
    required this.value,
    required this.date,
  });
}

class SubjectResult {
  final SubjectId id;
  final String name;
  final GradeValue? calculatedGrade;
  final WeightType weightType;
  final IMap<GradeTypeId, Weight> gradeTypeWeights;
  final IList<GradeResult> grades;
  final String abbreviation;
  final Design design;

  SubjectResult({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.calculatedGrade,
    required this.weightType,
    required this.gradeTypeWeights,
    required this.grades,
    required this.design,
  });

  GradeResult grade(GradeId gradeId) {
    return grades.firstWhere((element) => element.id == gradeId);
  }
}

class TermResult {
  final TermId id;
  final GradingSystem gradingSystem;
  final GradeValue? calculatedGrade;
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

class Grade {
  final GradeId id;

  /// Either a number or a string like '1+', '2-', etc.
  final Object value;
  final GradingSystem gradingSystem;
  final GradeTypeId type;
  final Date date;
  final bool takeIntoAccount;

  Grade({
    required this.id,
    required this.value,
    required this.gradingSystem,
    required this.type,
    required this.date,
    required this.takeIntoAccount,
  });
}

enum WeightType { perGrade, perGradeType, inheritFromTerm }

class GradeTypeId extends Id {
  const GradeTypeId(super.id);
}

class Subject {
  final SubjectId id;
  final Design design;
  final String name;
  final String abbreviation;

  Subject({
    required this.id,
    required this.design,
    required this.name,
    required this.abbreviation,
  });
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
