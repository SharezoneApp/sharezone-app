import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/subject_id.dart';
import 'package:sharezone/grades/term_id.dart';
import 'package:test_randomness/test_randomness.dart';

import 'grades_2_test.dart';

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
  });
}

class GradesTestController {
  late Term _term;

  void createTerm(TestTerm testTerm) {
    _term = Term();
    for (var subject in testTerm.subjects.values) {
      _term = _term.addSubject(Subject(subject.id.id));
      if (subject.weight != null) {
        _term = _term
            .subject(subject.id.id)
            .changeWeightingForTermGrade(subject.weight!.asFactor.toDouble());
      }

      for (var grade in subject.grades) {
        _term = _term.subject(subject.id.id).addGrade(
              Grade(id: GradeId(randomAlpha(4)), value: grade.value),
              takeIntoAccount: grade.includeInGradeCalculations,
            );
      }
    }
  }

  TermResult term(TermId id) {
    return TermResult(
      _term.getTermGrade(),
      IMap.fromEntries(_term.subjects.map((subject) =>
          MapEntry(SubjectId(subject.id), SubjectRes(subject.gradeVal!)))),
    );
  }
}

class Weight {
  final num asFactor;
  num get asPercentage => asFactor * 100;

  const Weight.percent(num percent) : asFactor = percent / 100;
  const Weight.factor(this.asFactor);
}

class TermResult {
  final num calculatedGrade;
  IMap<SubjectId, SubjectRes> subjects;

  SubjectRes subject(SubjectId id) {
    return SubjectRes(calculatedGrade);
  }

  TermResult(this.calculatedGrade, this.subjects);
}

class SubjectRes {
  final num calculatedGrade;

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
}) {
  return TestSubject(
    id: id,
    name: name,
    grades: IList(grades),
    weight: weight,
  );
}

class TestSubject {
  final SubjectId id;
  final String name;
  final IList<TestGrade> grades;
  final Weight? weight;

  TestSubject({
    required this.id,
    required this.name,
    required this.grades,
    this.weight,
  });
}

TestGrade gradeWith({
  required double value,
  bool includeInGradeCalculations = true,
}) {
  return TestGrade(
    value: value,
    includeInGradeCalculations: includeInGradeCalculations,
  );
}

class TestGrade {
  final double value;
  final bool includeInGradeCalculations;

  TestGrade({
    required this.value,
    required this.includeInGradeCalculations,
  });
}
