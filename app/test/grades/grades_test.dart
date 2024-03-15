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
            weightFactorForTermGrade: 0.5,
            grades: [gradeWith(value: 3.0)]),
        subjectWith(
            id: SubjectId('Mathe'),
            name: 'Mathe',
            weightFactorForTermGrade: 1,
            grades: [gradeWith(value: 3.0), gradeWith(value: 1.0)]),
        subjectWith(
            id: SubjectId('Informatik'),
            name: 'Informatik',
            weightFactorForTermGrade: 2,
            grades: [gradeWith(value: 1.0)]),
      ]);
      controller.createTerm(term);

      const weight1 = 0.5;
      const weight2 = 1;
      const weight3 = 2;

      const sumOfWeights = weight1 + weight2 + weight3;

      const expected = (3 * weight1 + 2 * weight2 + 1 * weight3) / sumOfWeights;

      expect(controller.term(term.id).calculatedGrade, expected);
    });
  });
}

class GradesTestController {
  late Term _term;

  void createTerm(TestTerm testTerm) {
    _term = Term();
    for (var subject in testTerm.subjects.values) {
      _term = _term.addSubject(Subject(subject.id.id));
      if (subject.weightFactorForTermGrade != null) {
        _term = _term.subject(subject.id.id).changeWeightingForTermGrade(
            subject.weightFactorForTermGrade!.toDouble());
      }

      for (var grade in subject.grades) {
        _term = _term
            .subject(subject.id.id)
            .addGrade(Grade(id: GradeId(randomAlpha(4)), value: grade.value));
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
  num? weightFactorForTermGrade,
}) {
  return TestSubject(
    id: id,
    name: name,
    grades: IList(grades),
    weightFactorForTermGrade: weightFactorForTermGrade,
  );
}

class TestSubject {
  final SubjectId id;
  final String name;
  final IList<TestGrade> grades;
  final num? weightFactorForTermGrade;

  TestSubject({
    required this.id,
    required this.name,
    required this.grades,
    this.weightFactorForTermGrade,
  });
}

TestGrade gradeWith({
  required double value,
}) {
  return TestGrade(
    value: value,
  );
}

class TestGrade {
  final double value;

  TestGrade({
    required this.value,
  });
}
