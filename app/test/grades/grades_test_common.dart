// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/src/date.dart';
import 'package:design/src/design.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:test_randomness/test_randomness.dart';

extension ValidValue on GradingSystem {
  Object get validGradeValue {
    return switch (this) {
      GradingSystem.austrianBehaviouralGrades => 'Zufriedenstellend',
      GradingSystem.oneToSixWithDecimals => 1.5,
      GradingSystem.oneToSixWithPlusAndMinus => 0.5,
      GradingSystem.sixToOneWithDecimals => 5.5,
      GradingSystem.zeroToFifteenPoints => 5,
      GradingSystem.zeroToFifteenPointsWithDecimals => 5.5,
      GradingSystem.zeroToHundredPercentWithDecimals => 0.5,
      GradingSystem.oneToFiveWithDecimals => 2.5,
    };
  }
}

class GradesTestController {
  GradesService service = GradesService();

  GradesTestController({GradesService? gradesService}) {
    service = gradesService ?? GradesService();
  }

  void createTerm(TestTerm testTerm, {bool createMissingGradeTypes = true}) {
    final termId = testTerm.id;

    if (createMissingGradeTypes) {
      for (var id in _getAllGradeTypeIds(testTerm)) {
        service.addCustomGradeType(
          GradeType(
            id: id,
            displayName: randomAlpha(5),
          ),
        );
      }
    }

    service.addTerm(
      id: termId,
      finalGradeType: testTerm.finalGradeType,
      isActiveTerm: testTerm.isActiveTerm,
      name: testTerm.name,
      gradingSystem: testTerm.gradingSystem,
    );

    if (testTerm.gradeTypeWeights != null) {
      for (var e in testTerm.gradeTypeWeights!.entries) {
        service.changeGradeTypeWeightForTerm(
          termId: termId,
          gradeType: e.key,
          weight: e.value,
        );
      }
    }

    for (var subject in testTerm.subjects.values) {
      service.addSubject(Subject(
        id: subject.id,
        name: subject.name,
        abbreviation: subject.abbreviation,
        design: subject.design,
        connectedCourses: subject.connectedCourses,
      ));

      // A subject is added to a term implicitly when adding a grade with the
      // subject id. So we need to add the grades here first before setting the
      // other settings (weights) that refer to the term.
      for (var grade in subject.grades) {
        service.addGrade(
          subjectId: subject.id,
          termId: termId,
          value: _toGrade(grade),
        );
        if (grade.weight != null) {
          service.changeGradeWeight(
            id: grade.id,
            termId: termId,
            weight: grade.weight!,
          );
        }
      }

      if (subject.weight != null) {
        service.changeSubjectWeightForTermGrade(
            id: subject.id, termId: termId, weight: subject.weight!);
      }

      if (subject.weightType != null) {
        service.changeSubjectWeightTypeSettings(
            id: subject.id, termId: termId, perGradeType: subject.weightType!);
      }

      for (var e in subject.gradeTypeWeights.entries) {
        service.changeGradeTypeWeightForSubject(
            id: subject.id, termId: termId, gradeType: e.key, weight: e.value);
      }

      if (subject.finalGradeType != null) {
        service.changeSubjectFinalGradeType(
            id: subject.id, termId: termId, gradeType: subject.finalGradeType!);
      }
    }
  }

  IList<GradeTypeId> _getAllGradeTypeIds(TestTerm testTerm) {
    final ids = IList<GradeTypeId>()
        .add(testTerm.finalGradeType)
        .addAll(
          testTerm.gradeTypeWeights?.keys ?? [],
        )
        .addAll([
      for (var subject in testTerm.subjects.values)
        ..._getAllGradeTypeIdsForSubject(subject),
    ]);

    return ids;
  }

  IList<GradeTypeId> _getAllGradeTypeIdsForSubject(TestSubject testSubject) {
    return testSubject.gradeTypeWeights.keys
        .toIList()
        .addAll(testSubject.finalGradeType != null
            ? [testSubject.finalGradeType!]
            : [])
        .addAll(testSubject.grades.map((g) => g.type));
  }

  Grade _toGrade(TestGrade testGrade) {
    return Grade(
      id: testGrade.id,
      value: testGrade.value,
      date: testGrade.date,
      takeIntoAccount: testGrade.includeInGradeCalculations,
      gradingSystem: testGrade.gradingSystem,
      type: testGrade.type,
      title: testGrade.title,
      details: testGrade.details,
    );
  }

  List<TermResult> get terms => service.terms.value.toList(growable: false);

  TermResult term(TermId id) {
    final term = service.terms.value.singleWhere((t) => t.id == id);

    return term;
  }

  void changeWeightTypeForSubject(
      {required TermId termId,
      required SubjectId subjectId,
      required WeightType weightType}) {
    service.changeSubjectWeightTypeSettings(
        id: subjectId, termId: termId, perGradeType: weightType);
  }

  void removeWeightTypeForSubject({
    required GradeTypeId gradeTypeId,
    required TermId termId,
    required SubjectId subjectId,
  }) {
    service.removeGradeTypeWeightForSubject(
      gradeType: gradeTypeId,
      id: subjectId,
      termId: termId,
    );
  }

  void removeGradeTypeWeightForTerm({
    required GradeTypeId gradeTypeId,
    required TermId termId,
  }) {
    service.removeGradeTypeWeightForTerm(
        gradeType: gradeTypeId, termId: termId);
  }

  void changeGradeWeightsForSubject(
      {required TermId termId,
      required SubjectId subjectId,
      required Map<GradeId, Weight> weights}) {
    for (var e in weights.entries) {
      service.changeGradeWeight(
        id: e.key,
        termId: termId,
        weight: e.value,
      );
    }
  }

  void changeTermWeightsForSubject(
      {required TermId termId,
      required SubjectId subjectId,
      required Map<GradeTypeId, Weight> gradeTypeWeights}) {
    for (var e in gradeTypeWeights.entries) {
      service.changeGradeTypeWeightForSubject(
          id: subjectId, termId: termId, gradeType: e.key, weight: e.value);
    }
  }

  void changeFinalGradeTypeForSubject(
      {required TermId termId,
      required SubjectId subjectId,
      required GradeTypeId? gradeType}) {
    service.changeSubjectFinalGradeType(
        id: subjectId, termId: termId, gradeType: gradeType);
  }

  IList<GradeType> getPossibleGradeTypes() {
    return service.getPossibleGradeTypes();
  }

  IList<GradeType> getCustomGradeTypes() {
    return getPossibleGradeTypes()
        .where((gt) => gt.predefinedType == null)
        .toIList();
  }

  void createCustomGradeType(GradeType gradeType) {
    return service.addCustomGradeType(gradeType);
  }

  void addGrade({
    required TermId termId,
    required SubjectId subjectId,
    required TestGrade value,
  }) {
    return service.addGrade(
      subjectId: subjectId,
      termId: termId,
      value: _toGrade(value),
    );
  }

  void addSubject(TestSubject subject) {
    service.addSubject(Subject(
      id: subject.id,
      name: subject.name,
      abbreviation: subject.abbreviation,
      design: subject.design,
      connectedCourses: subject.connectedCourses,
    ));
  }

  IList<TestSubject> getSubjects() {
    return service
        .getSubjects()
        .map(
          (subject) => TestSubject(
            id: subject.id,
            name: subject.name,
            abbreviation: subject.abbreviation,
            connectedCourses: subject.connectedCourses,
            design: subject.design,
            grades: IList(const []),
            gradeTypeWeights: <GradeTypeId, Weight>{},
          ),
        )
        .toIList();
  }

  void editTerm(
    TermId id, {
    bool? isActiveTerm,
    String? name,
    GradeTypeId? finalGradeType,
    GradingSystem? gradingSystem,
  }) {
    service.editTerm(
      id: id,
      isActiveTerm: isActiveTerm,
      name: name,
      finalGradeType: finalGradeType,
      gradingSystem: gradingSystem,
    );
  }

  void deleteTerm(TermId id) {
    service.deleteTerm(id);
  }

  void deleteGrade({required GradeId gradeId}) {
    service.deleteGrade(gradeId);
  }
}

TestTerm termWith({
  TermId? id,
  String? name,
  List<TestSubject> subjects = const [],
  Map<GradeTypeId, Weight>? gradeTypeWeights,
  GradeTypeId finalGradeType = const GradeTypeId('Endnote'),
  bool isActiveTerm = true,
  GradingSystem? gradingSystem,
}) {
  final rdm = randomAlpha(5);
  final idd = id ?? TermId(rdm);
  return TestTerm(
    id: idd,
    name: name ?? '$idd',
    subjects: IMap.fromEntries(subjects.map((s) => MapEntry(s.id, s))),
    gradingSystem: gradingSystem ?? GradingSystem.zeroToFifteenPoints,
    gradeTypeWeights: gradeTypeWeights,
    finalGradeType: finalGradeType,
    isActiveTerm: isActiveTerm,
  );
}

class TestTerm {
  final TermId id;
  final String name;
  final IMap<SubjectId, TestSubject> subjects;
  final GradingSystem gradingSystem;
  final Map<GradeTypeId, Weight>? gradeTypeWeights;
  final GradeTypeId finalGradeType;
  final bool isActiveTerm;

  TestTerm({
    required this.id,
    required this.name,
    required this.subjects,
    required this.finalGradeType,
    this.gradeTypeWeights,
    required this.isActiveTerm,
    required this.gradingSystem,
  });
}

TestSubject subjectWith({
  SubjectId? id,
  String? name,
  String? abbreviation,
  List<TestGrade> grades = const [],
  Weight? weight,
  WeightType? weightType,
  Map<GradeTypeId, Weight> gradeTypeWeights = const {},
  GradeTypeId? finalGradeType,
  Design? design,
  List<ConnectedCourse> connectedCourses = const [],
}) {
  final idRes = id ?? SubjectId(randomAlpha(5));
  final nameRes = name ?? idRes.value;
  final abbreviationRes = abbreviation ?? nameRes.substring(0, 2);
  return TestSubject(
    id: idRes,
    name: nameRes,
    abbreviation: abbreviationRes,
    grades: IList(grades),
    weight: weight,
    connectedCourses: connectedCourses.toIList(),
    weightType: weightType,
    gradeTypeWeights: gradeTypeWeights,
    finalGradeType: finalGradeType,
    design: design ?? Design.random(szTestRandom),
  );
}

class TestSubject {
  final SubjectId id;
  final String name;
  final IList<TestGrade> grades;
  final WeightType? weightType;
  final Map<GradeTypeId, Weight> gradeTypeWeights;
  final Weight? weight;
  final GradeTypeId? finalGradeType;
  final Design design;
  final String abbreviation;
  final IList<ConnectedCourse> connectedCourses;

  TestSubject({
    required this.id,
    required this.name,
    required this.grades,
    required this.gradeTypeWeights,
    required this.design,
    required this.abbreviation,
    this.connectedCourses = const IListConst([]),
    this.weightType,
    this.weight,
    this.finalGradeType,
  }) : assert(() {
          // Help developers to not forget to set the weightType if
          // gradeTypeWeights or grade weights are set. This is not a hard
          // requirement by the logic, so if you need to do it anyways then you
          // might edit this assert.
          if (gradeTypeWeights.isNotEmpty) {
            return weightType == WeightType.perGradeType;
          }
          if (grades.any((g) => g.weight != null)) {
            return weightType == WeightType.perGrade;
          }

          return true;
        }());
}

TestGrade gradeWith({
  required Object value,
  bool includeInGradeCalculations = true,
  GradeTypeId? type,
  Weight? weight,
  GradeId? id,
  GradingSystem? gradingSystem,
  Date? date,
  String? title,
  String? details,
}) {
  return TestGrade(
    id: id ?? GradeId(randomAlpha(5)),
    value: value,
    includeInGradeCalculations: includeInGradeCalculations,
    date: date ?? Date('2024-02-22'),
    gradingSystem: gradingSystem ?? GradingSystem.zeroToFifteenPoints,
    type: type ?? GradeType.other.id,
    title: title ?? 'Exam',
    details: details ?? randomAlpha(5),
    weight: weight,
  );
}

class TestGrade {
  final GradeId id;

  /// Either a [num] or [String]
  final Object value;
  final bool includeInGradeCalculations;
  final GradingSystem gradingSystem;
  final GradeTypeId type;
  final Weight? weight;
  final Date date;
  final String title;
  final String details;

  TestGrade({
    required this.id,
    required this.value,
    required this.date,
    required this.includeInGradeCalculations,
    required this.gradingSystem,
    required this.type,
    required this.title,
    required this.details,
    this.weight,
  }) {
    if (value is! num && value is! String) {
      throw ArgumentError.value(
        value,
        'value',
        'Must be a num or a String, but was ${value.runtimeType}',
      );
    }
  }
}
