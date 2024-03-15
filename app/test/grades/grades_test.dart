import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/subject_id.dart';
import 'package:sharezone/grades/term_id.dart';
import 'package:test_randomness/test_randomness.dart';

import 'grades_2_test.dart';

void main() {
  group('grades', () {
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
  });
}

class GradesTestController {
  late Term _term;

  void createTerm(TestTerm testTerm) {
    _term = Term();
    for (var subject in testTerm.subjects.values) {
      _term = _term.addSubject(Subject(subject.id.id));
      for (var grade in subject.grades) {
        _term = _term
            .subject(subject.id.id)
            .addGrade(Grade(id: GradeId(randomAlpha(4)), value: grade.value));
      }
    }
  }

  TermResult term(TermId id) {
    return TermResult(_term.getTermGrade());
  }
}

class TermResult {
  final num calculatedGrade;

  TermResult(this.calculatedGrade);
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
}) {
  return TestSubject(
    id: id,
    name: name,
    grades: IList(grades),
  );
}

class TestSubject {
  final SubjectId id;
  final String name;
  final IList<TestGrade> grades;

  TestSubject({
    required this.id,
    required this.name,
    required this.grades,
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
