import 'package:flutter_test/flutter_test.dart';

void main() {
  group('grades', () {
    test('test name', () {
      final englisch = subjectWith(name: 'Englisch', withGrades: [
        gradeWith(value: 2),
        gradeWith(value: 3),
        gradeWith(value: 1),
      ]);

      expect(englisch.getAverageGrade(), 2.0);
    });
  });
}

class Subject {
  final String name;
  final List<Grade> grades;

  Subject({required this.name, required this.grades});

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
  return Subject(name: name, grades: withGrades);
}

Grade gradeWith({required int value}) {
  return Grade(value: value);
}
