import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/subject_id.dart';

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
