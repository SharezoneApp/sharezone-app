import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/subject_id.dart';
import 'package:sharezone/grades/term_id.dart';
import 'package:test_randomness/test_randomness.dart';

import 'grades_2_test.dart';
import 'grades_service.dart';

void main() {
  group('grades', () {
    test(
        'The calculated grade of a subject is the average of the grades by default',
        () {
      final controller = GradesTestController();

      final term = termWith(name: '1. Halbjahr', subjects: [
        subjectWith(
            id: SubjectId('Mathe'),
            name: 'Mathe',
            grades: [gradeWith(value: 4), gradeWith(value: 1.5)]),
      ]);
      controller.createTerm(term);

      expect(
          controller.term(term.id).subject(SubjectId('Mathe')).calculatedGrade,
          2.75);
    });
    test(
        'The calculated grade of the term is the average of subject grades by default',
        () {
      final controller = GradesTestController();

      final term = termWith(name: '1. Halbjahr', subjects: [
        subjectWith(
            id: SubjectId('Deutsch'),
            name: 'Deutsch',
            grades: [gradeWith(value: 3.0), gradeWith(value: 1.0)]),
        subjectWith(
            id: SubjectId('Englisch'),
            name: 'Englisch',
            grades: [gradeWith(value: 2.0), gradeWith(value: 4.0)]),
      ]);
      controller.createTerm(term);

      expect(controller.term(term.id).calculatedGrade, 2.5);
    });
    test(
        'the term grade should equal the average of the average grades of every subject taking weightings into account',
        () {
      final controller = GradesTestController();

      final term = termWith(name: '1. Halbjahr', subjects: [
        subjectWith(
            id: SubjectId('Englisch'),
            name: 'Englisch',
            weight: const Weight.factor(0.5),
            grades: [gradeWith(value: 3.0)]),
        subjectWith(
            id: SubjectId('Mathe'),
            name: 'Mathe',
            weight: const Weight.factor(1),
            grades: [gradeWith(value: 3.0), gradeWith(value: 1.0)]),
        subjectWith(
            id: SubjectId('Informatik'),
            name: 'Informatik',
            // weight: const Weight.factor(2),
            // is the same as:
            weight: const Weight.percent(200),
            grades: [gradeWith(value: 1.0)]),
      ]);
      controller.createTerm(term);

      const sumOfWeights = 0.5 + 1 + 2;
      const expected = (3 * 0.5 + 2 * 1 + 1 * 2) / sumOfWeights;
      expect(controller.term(term.id).calculatedGrade, expected);
    });
    test(
        'grades that are marked as "Nicht in den Schnitt einbeziehen" should not be included in the calculation of the subject and term grade',
        () {
      final controller = GradesTestController();

      final term = termWith(name: '1. Halbjahr', subjects: [
        subjectWith(
            id: SubjectId('Sport'),
            name: 'Sport',
            weight: const Weight.factor(0.5),
            grades: [
              gradeWith(value: 3.0, includeInGradeCalculations: false),
              gradeWith(value: 1.5),
            ]),
      ]);
      controller.createTerm(term);

      expect(
          controller.term(term.id).subject(SubjectId('Sport')).calculatedGrade,
          1.5);
      expect(controller.term(term.id).calculatedGrade, 1.5);
    });
    test('subjects can have custom weights per grade type (e.g. presentation)',
        () {
      final controller = GradesTestController();

      final term = termWith(name: '2. Halbjahr', subjects: [
        subjectWith(
            id: SubjectId('Englisch'),
            name: 'Englisch',
            gradeTypeWeights: {
              const GradeType('presentation'): const Weight.factor(0.7),
              const GradeType('vocabulary test'): const Weight.factor(1),
              const GradeType('exam'): const Weight.factor(1.5),
            },
            grades: [
              gradeWith(value: 2.0, type: const GradeType('presentation')),
              gradeWith(value: 1.0, type: const GradeType('exam')),
              gradeWith(value: 1.0, type: const GradeType('vocabulary test')),
            ]),
      ]);
      controller.createTerm(term);

      const sumOfWeights = 0.7 + 1.5 + 1;
      const expected = (2 * 0.7 + 1 * 1.5 + 1 * 1) / sumOfWeights;
      expect(
          controller
              .term(term.id)
              .subject(SubjectId('Englisch'))
              .calculatedGrade,
          expected);
      expect(controller.term(term.id).calculatedGrade, expected);
    });
    test(
        'subjects can have custom weights per grade type 2 (e.g. presentation)',
        () {
      // Aus Beispiel: https://www.notenapp.com/2023/08/01/notendurchschnitt-berechnen-wie-mache-ich-es-richtig/

      final controller = GradesTestController();

      final term = termWith(name: '2. Halbjahr', subjects: [
        subjectWith(
          id: SubjectId('Mathe'),
          name: 'Mathe',
          gradeTypeWeights: {
            const GradeType('Schulaufgabe'): const Weight.factor(2),
            const GradeType('Abfrage'): const Weight.factor(1),
            const GradeType('Mitarbeitsnote'): const Weight.factor(1),
            const GradeType('Referat'): const Weight.factor(1),
          },
          grades: [
            gradeWith(value: 2.0, type: const GradeType('Schulaufgabe')),
            gradeWith(value: 3.0, type: const GradeType('Schulaufgabe')),
            gradeWith(value: 1.0, type: const GradeType('Abfrage')),
            gradeWith(value: 3.0, type: const GradeType('Abfrage')),
            gradeWith(value: 2.0, type: const GradeType('Mitarbeitsnote')),
            gradeWith(value: 1.0, type: const GradeType('Referat')),
          ],
        ),
      ]);
      controller.createTerm(term);

      expect(
          controller.term(term.id).subject(SubjectId('Mathe')).calculatedGrade,
          2.125);
    });
  });
}

class GradesTestController {
  final service = GradesService();

  void createTerm(TestTerm testTerm) {
    final termId = testTerm.id;
    service.createTerm(id: termId);
    for (var subject in testTerm.subjects.values) {
      service.addSubject(id: subject.id, toTerm: termId);
      if (subject.weight != null) {
        service.changeSubjectWeightForTermGrade(
            id: subject.id, termId: termId, weight: subject.weight!);
      }

      for (var e in subject.gradeTypeWeights.entries) {
        service.changeSubjectWeightTypeSettings(
            id: subject.id,
            termId: termId,
            perGradeType: WeightType.perGradeType);

        service.changeGradeTypeWeightForSubject(
            id: subject.id, termId: termId, gradeType: e.key, weight: e.value);
      }

      for (var grade in subject.grades) {
        service.addGrade(
          id: subject.id,
          termId: termId,
          value: Grade(id: grade.id, value: grade.value, type: grade.type),
          takeIntoAccount: grade.includeInGradeCalculations,
        );
      }
    }
  }

  TermResult term(TermId id) {
    final term = service.terms.value.single;

    return term;
  }
}

class Weight {
  final num asFactor;
  num get asPercentage => asFactor * 100;

  const Weight.percent(num percent) : asFactor = percent / 100;
  const Weight.factor(this.asFactor);
}

class TermResult {
  final num? calculatedGrade;
  IMap<SubjectId, SubjectRes> subjects;

  SubjectRes subject(SubjectId id) {
    return SubjectRes(calculatedGrade);
  }

  TermResult(this.calculatedGrade, this.subjects);
}

class SubjectRes {
  final num? calculatedGrade;

  SubjectRes(this.calculatedGrade);
}

TestTerm termWith({
  required String name,
  required List<TestSubject> subjects,
}) {
  return TestTerm(
    id: TermId('1'),
    name: name,
    subjects: IMap.fromEntries(subjects.map((s) => MapEntry(s.id, s))),
  );
}

class TestTerm {
  final TermId id;
  final String name;
  final IMap<SubjectId, TestSubject> subjects;

  TestTerm({
    required this.id,
    required this.name,
    required this.subjects,
  });
}

TestSubject subjectWith({
  required SubjectId id,
  required String name,
  required List<TestGrade> grades,
  Weight? weight,
  Map<GradeType, Weight> gradeTypeWeights = const {},
}) {
  return TestSubject(
    id: id,
    name: name,
    grades: IList(grades),
    weight: weight,
    gradeTypeWeights: gradeTypeWeights,
  );
}

class TestSubject {
  final SubjectId id;
  final String name;
  final IList<TestGrade> grades;
  final Map<GradeType, Weight> gradeTypeWeights;
  final Weight? weight;

  TestSubject({
    required this.id,
    required this.name,
    required this.grades,
    required this.gradeTypeWeights,
    this.weight,
  });
}

TestGrade gradeWith({
  required double value,
  bool includeInGradeCalculations = true,
  GradeType type = const GradeType('some test type'),
}) {
  return TestGrade(
    id: GradeId(randomAlpha(5)),
    value: value,
    includeInGradeCalculations: includeInGradeCalculations,
    type: type,
  );
}

class TestGrade {
  final GradeId id;
  final double value;
  final bool includeInGradeCalculations;
  final GradeType type;

  TestGrade({
    required this.id,
    required this.value,
    required this.includeInGradeCalculations,
    required this.type,
  });
}
