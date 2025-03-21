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

  void createTerm(
    TestTerm testTerm, {
    bool createMissingGradeTypes = true,

    /// If true, throws error if a subject of the term has no grades.
    ///
    /// Is true by default to prevent developers from being confused when they
    /// create a term with a subject that has no grades and then try to access
    /// the subject of the term. This would throw an error as the term won't
    /// have the subject added, as it has no grades for it (yet).
    ///
    /// If you acknowledge this behavior and want to manually add grades to the
    /// subject later, set this to false.
    bool throwErrorForSubjectsWithNoGrades = true,
  }) {
    final termId = testTerm.id;
    final termRef = service.term(termId);

    if (createMissingGradeTypes) {
      for (var id in _getAllGradeTypeIds(testTerm)) {
        service.addCustomGradeType(id: id, displayName: randomAlpha(5));
      }
    }

    service.addTerm(
      id: termId,
      finalGradeType: testTerm.finalGradeType,
      isActiveTerm: testTerm.isActiveTerm,
      name: testTerm.name,
      gradingSystem: testTerm.gradingSystem,
      gradeTypeWeights: testTerm.gradeTypeWeights?.toIMap(),
    );

    if (testTerm.weightDisplayType != null) {
      service.term(termId).changeWeightDisplayType(testTerm.weightDisplayType!);
    }

    for (var subject in testTerm.subjects.values) {
      final subRef = termRef.subject(subject.id);

      if (subject.grades.isEmpty && throwErrorForSubjectsWithNoGrades) {
        throw ArgumentError("""
The subject "${subject.name}" was added to the term "${testTerm.name}", but it has no grades.
Inside the $GradesService a subject is only really added to a term when a grade is added for this subject.
Either add a grade to the subject when creating it or set `throwErrorForSubjectsWithNoGrades` to false if you acknowledge this behavior and want to manually add grades later to the subject.

This error is created so that developers are not confused in this case:
```
testController.createTerm(termWith(id: TermId('foo'), subjects: [
  subjectWith(id: SubjectId('maths')),
]));
// Throws error as the term does not have the 'maths' subject, because 
// it was not added to the term because there is no grade for 'maths' fo
// this term.
testController.term(TermId('foo')).subject(SubjectId('maths')).name;
```
""");
      }

      service.addSubject(
        id: subject.id,
        SubjectInput(
          name: subject.name,
          abbreviation: subject.abbreviation,
          design: subject.design,
          connectedCourses: subject.connectedCourses,
        ),
      );

      // A subject is added to a term implicitly when adding a grade with the
      // subject id. So we need to add the grades here first before setting the
      // other settings (weights) that refer to the term.
      for (var grade in subject.grades) {
        final gradeRef = subRef.addGrade(_toGrade(grade), id: grade.id);

        if (grade.weight != null) {
          gradeRef.changeWeight(grade.weight!);
        }
      }

      if (subject.weight != null) {
        subRef.changeWeightForTermGrade(subject.weight!);
      }

      if (subject.weightType != null) {
        subRef.changeWeightType(subject.weightType!);
      }

      for (var e in subject.gradeTypeWeights.entries) {
        subRef.changeGradeTypeWeight(e.key, e.value);
      }

      if (subject.finalGradeType != null) {
        subRef.changeFinalGradeType(subject.finalGradeType!);
      }
    }
  }

  IList<GradeTypeId> _getAllGradeTypeIds(TestTerm testTerm) {
    final ids = IList<GradeTypeId>()
        .add(testTerm.finalGradeType)
        .addAll(testTerm.gradeTypeWeights?.keys ?? [])
        .addAll([
          for (var subject in testTerm.subjects.values)
            ..._getAllGradeTypeIdsForSubject(subject),
        ]);

    return ids;
  }

  IList<GradeTypeId> _getAllGradeTypeIdsForSubject(TestSubject testSubject) {
    return testSubject.gradeTypeWeights.keys
        .toIList()
        .addAll(
          testSubject.finalGradeType != null
              ? [testSubject.finalGradeType!]
              : [],
        )
        .addAll(testSubject.grades.map((g) => g.type));
  }

  GradeInput _toGrade(TestGrade testGrade) {
    return GradeInput(
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

  void changeWeightTypeForSubject({
    required TermId termId,
    required SubjectId subjectId,
    required WeightType weightType,
  }) {
    service.term(termId).subject(subjectId).changeWeightType(weightType);
  }

  void removeWeightTypeForSubject({
    required GradeTypeId gradeTypeId,
    required TermId termId,
    required SubjectId subjectId,
  }) {
    service.term(termId).subject(subjectId).removeGradeTypeWeight(gradeTypeId);
  }

  void removeGradeTypeWeightForTerm({
    required GradeTypeId gradeTypeId,
    required TermId termId,
  }) {
    service.term(termId).removeGradeTypeWeight(gradeTypeId);
  }

  void changeGradeWeightsForSubject({
    required TermId termId,
    required SubjectId subjectId,
    required Map<GradeId, Weight> weights,
  }) {
    final subRef = service.term(termId).subject(subjectId);
    for (var e in weights.entries) {
      final gradeRef = subRef.grade(e.key);
      gradeRef.changeWeight(e.value);
    }
  }

  void changeTermWeightsForSubject({
    required TermId termId,
    required SubjectId subjectId,
    required Map<GradeTypeId, Weight> gradeTypeWeights,
  }) {
    final subRef = service.term(termId).subject(subjectId);
    for (var e in gradeTypeWeights.entries) {
      subRef.changeGradeTypeWeight(e.key, e.value);
    }
  }

  void changeGradeTypeWeightForTerm({
    required TermId termId,
    required Map<GradeTypeId, Weight> gradeTypeWeights,
  }) {
    for (var e in gradeTypeWeights.entries) {
      service.term(termId).changeGradeTypeWeight(e.key, e.value);
    }
  }

  void changeFinalGradeTypeForSubject({
    required TermId termId,
    required SubjectId subjectId,
    required GradeTypeId? gradeType,
  }) {
    service.term(termId).subject(subjectId).changeFinalGradeType(gradeType);
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
    service.addCustomGradeType(
      displayName: gradeType.displayName ?? gradeType.predefinedType.toString(),
      id: gradeType.id,
    );
  }

  void addGrade({
    required TermId termId,
    required SubjectId subjectId,
    required TestGrade value,
  }) {
    service
        .term(termId)
        .subject(subjectId)
        .addGrade(_toGrade(value), id: value.id);
  }

  void addSubject(TestSubject subject) {
    service.addSubject(
      id: subject.id,
      SubjectInput(
        name: subject.name,
        abbreviation: subject.abbreviation,
        design: subject.design,
        connectedCourses: subject.connectedCourses,
      ),
    );

    if (subject.grades.isNotEmpty) {
      throw ArgumentError('Use addGrade to add grades to a subject');
    }
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
    final termRef = service.term(id);

    if (isActiveTerm != null) {
      termRef.changeActiveTerm(isActiveTerm);
    }

    if (name != null) {
      termRef.changeName(name);
    }

    if (finalGradeType != null) {
      termRef.changeFinalGradeType(finalGradeType);
    }

    if (gradingSystem != null) {
      termRef.changeGradingSystem(gradingSystem);
    }
  }

  void deleteTerm(TermId id) {
    service.term(id).delete();
  }

  void editGrade(TestGrade grade) {
    if (grade.weight != null) {
      throw UnimplementedError();
    }
    service.grade(grade.id).edit(_toGrade(grade));
  }

  void deleteGrade({required GradeId gradeId}) {
    service.grade(gradeId).delete();
  }

  void deleteCustomGradeType(GradeTypeId gradeTypeId) {
    service.deleteCustomGradeType(gradeTypeId);
  }

  void changeFinalGradeTypeForTerm({
    required TermId termId,
    required GradeTypeId gradeTypeId,
  }) {
    service.term(termId).changeFinalGradeType(gradeTypeId);
  }

  void editCustomGradeType(GradeTypeId id, {required String displayName}) {
    service.editCustomGradeType(id: id, displayName: displayName);
  }

  void createTerms(List<TestTerm> list, {bool createMissingGradeTypes = true}) {
    for (var term in list) {
      createTerm(term, createMissingGradeTypes: createMissingGradeTypes);
    }
  }

  void changeWeightDisplayTypeForTerm({
    required TermId termId,
    required WeightDisplayType weightDisplayType,
  }) {
    service.term(termId).changeWeightDisplayType(weightDisplayType);
  }

  void changeTermSubjectWeights({
    required TermId termId,
    required Map<SubjectId, Weight> subjectWeights,
  }) {
    for (var e in subjectWeights.entries) {
      service.term(termId).subject(e.key).changeWeightForTermGrade(e.value);
    }
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
  WeightDisplayType? weightDisplayType,
}) {
  final rdm = randomAlpha(5);
  final idd = id ?? TermId(rdm);
  return TestTerm(
    id: idd,
    name: name ?? '$idd',
    subjects: IMap.fromEntries(subjects.map((s) => MapEntry(s.id, s))),
    gradingSystem: gradingSystem ?? GradingSystem.zeroToFifteenPoints,
    weightDisplayType: weightDisplayType,
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
  final WeightDisplayType? weightDisplayType;
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
    required this.weightDisplayType,
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
  bool ignoreWeightTypeAssertion = false,
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
    ignoreWeightTypeAssertion: ignoreWeightTypeAssertion,
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
    bool ignoreWeightTypeAssertion = false,
  }) : assert(() {
         if (ignoreWeightTypeAssertion) return true;
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
  Object? value,
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
    value: value ?? randomBetween(0, 15),
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
