import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('grades', () {
    test('get average grade of two different subjects in term', () {
      final term = Term();
      final englisch = Subject('Englisch');

      term.addSubject(englisch);
      term.addGrade(3.0, toSubject: englisch.id);
      term.addGrade(1.0, toSubject: englisch.id);

      expect(term.getAverageGradeForSubject(englisch.id), 2.0);

      final mathe = Subject('Mathe');
      term.addSubject(mathe);
      term.addGrade(2.0, toSubject: mathe.id);
      term.addGrade(4.0, toSubject: mathe.id);

      expect(term.getAverageGradeForSubject(mathe.id), 3.0);
    });
  });
}

class Term {
  final _subjects = <String, ({num total, int nrOfGrades})>{};

  void addGrade(double grade, {required String toSubject}) {
    final total = _subjects[toSubject]?.total ?? 0;
    final nrOfGrades = _subjects[toSubject]?.nrOfGrades ?? 0;

    _subjects[toSubject] = (total: total + grade, nrOfGrades: nrOfGrades + 1);
  }

  void addSubject(Subject subject) {}

  num getAverageGradeForSubject(String id) {
    final total = _subjects[id]!.total;
    final nrOfGrades = _subjects[id]!.nrOfGrades;

    return total / nrOfGrades;
  }
}

class Subject {
  final String id;

  Subject(this.id);
}
