import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/subject_id.dart';
import 'package:sharezone/grades/term_id.dart';

void main() {
  group('grades', () {
    test('test name', () {
      final controller = GradesTestController();

      final englisch = subjectWith(name: 'Englisch', withGrades: [
        gradeWith(value: 2),
        gradeWith(value: 3),
        gradeWith(value: 1),
      ]);

      controller.addSubject(englisch);

      expect(controller.getAverageGradeForSubject(englisch.id), 2.0);
    });

    test('term', () {
      final controller = GradesTestController();

      final term = termWith(name: '1. Halbjahr');
      controller.addTerm(term);

      final englisch = subjectWith(name: 'Englisch', withGrades: [
        gradeWith(value: 2),
        gradeWith(value: 4),
      ]);

      final mathe = subjectWith(name: 'Mathe', withGrades: [
        gradeWith(value: 1),
        gradeWith(value: 3),
      ]);

      controller.addSubjectToTerm(englisch, term.id);
      controller.addSubjectToTerm(mathe, term.id);

      expect(controller.getAverageGradeWithAllSubjects(), 2.5);
    });
  });
}

class GradesTestController {
  final List<Subject> _subjects = [];

  void addSubject(Subject subject) {
    _subjects.add(subject);
  }

  double getAverageGradeForSubject(SubjectId id) {
    final subject = _subjects.firstWhere((subject) => subject.id == id);
    return subject.getAverageGrade();
  }

  num getAverageGradeWithAllSubjects() {
    return _subjects
            .map((subject) => subject.getAverageGrade())
            .reduce((a, b) => a + b) /
        _subjects.length;
  }

  void addSubjectToTerm(Subject subject, TermId id) {
    addSubject(subject);
  }

  void addTerm(Term term) {}
}

Term termWith({required String name}) {
  return Term(id: TermId(name), name: name);
}

class Term {
  final TermId id;
  final String name;

  Term({required this.id, required this.name});
}

class Subject {
  final SubjectId id;
  final String name;
  final List<Grade> grades;

  Subject({required this.id, required this.name, required this.grades});

  double getAverageGrade() {
    return grades.map((grade) => grade.value).reduce((a, b) => a + b) /
        grades.length;
  }
}

class Grade {
  final int value;

  Grade({required this.value});
}

Subject subjectWith({required String name, required List<Grade> withGrades}) {
  return Subject(id: SubjectId(name), name: name, grades: withGrades);
}

Grade gradeWith({required int value}) {
  return Grade(value: value);
}
