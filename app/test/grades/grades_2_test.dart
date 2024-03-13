import 'package:flutter_test/flutter_test.dart';

void main() {
  group('grades', () {
    test('get average grade of subject in term', () {
      final term = Term();
      final englisch = Subject('Englisch');

      term.addSubject(englisch);
      term.addGrade(3.0, toSubject: englisch.id);
      term.addGrade(1.0, toSubject: englisch.id);

      expect(term.getAverageGradeForSubject(englisch.id), 2.0);
    });
  });
}

class Term {
  num total = 0;
  num nrOfSubjects = 0;

  void addGrade(double grade, {required String toSubject}) {
    total += grade;
    nrOfSubjects++;
  }

  void addSubject(Subject subject) {}

  num getAverageGradeForSubject(String id) {
    return total / nrOfSubjects;
  }
}

class Subject {
  final String id;

  Subject(this.id);
}
