import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('grades', () {
    test('get average grade of two different subjects in term', () {
      var term = Term();
      final englisch = Subject('Englisch');

      term = term.addGrade(3.0, toSubject: englisch.id);
      term = term.addGrade(1.0, toSubject: englisch.id);

      expect(term.getAverageGradeForSubject(englisch.id), 2.0);

      final mathe = Subject('Mathe');
      term = term.addGrade(2.0, toSubject: mathe.id);
      term = term.addGrade(4.0, toSubject: mathe.id);

      expect(term.getAverageGradeForSubject(mathe.id), 3.0);
    });

    test(
        'the average grade of the term should equal the average of the average grades of every subject',
        () {
      var term = Term();
      final englisch = Subject('Englisch');

      term = term.addGrade(3.0, toSubject: englisch.id);
      term = term.addGrade(1.0, toSubject: englisch.id);

      final mathe = Subject('Mathe');
      term = term.addGrade(2.0, toSubject: mathe.id);
      term = term.addGrade(4.0, toSubject: mathe.id);

      expect(term.getAverageGrade(), 2.5);
    });
    test(
        'the average grade of the term should equal the average of the average grades of every subject taking weightings into account',
        () {
      var term = Term();
      // final englisch = Subject('Englisch');
      // term = term.addGrade(3.0, toSubject: englisch.id);

      final mathe = Subject('Mathe');
      term = term.addGrade(2.0, toSubject: mathe.id);

      final informatik = Subject('Informatik');
      term = term.addGrade(1.0, toSubject: informatik.id);

      // term.changeWeighting(englisch.id, 1);
      // term.changeWeighting(mathe.id, 1);
      term = term.changeWeighting(informatik.id, 2);

      expect(term.getAverageGrade(), 1.25);
    }, skip: true);
  });
}

class Term {
  final IMap<String, ({num total, int nrOfGrades})> _subjects;

  Term() : _subjects = const IMapConst({});
  Term.internal(this._subjects);

  Term addGrade(double grade, {required String toSubject}) {
    final total = _subjects[toSubject]?.total ?? 0;
    final nrOfGrades = _subjects[toSubject]?.nrOfGrades ?? 0;

    final s = _subjects
        .add(toSubject, (total: total + grade, nrOfGrades: nrOfGrades + 1));

    return _copyWith(subjects: s);
  }

  num getAverageGradeForSubject(String id) {
    final total = _subjects[id]!.total;
    final nrOfGrades = _subjects[id]!.nrOfGrades;

    return total / nrOfGrades;
  }

  Term _copyWith({
    IMap<String, ({num total, int nrOfGrades})>? subjects,
  }) {
    return Term.internal(subjects ?? _subjects);
  }

  num getAverageGrade() {
    final averageGrades = _subjects.values.map((e) => e.total / e.nrOfGrades);
    return averageGrades.reduce((a, b) => a + b) / _subjects.length;
  }

  Term changeWeighting(String id, int newWeight) {
    return this;
  }
}

class Subject {
  final String id;

  Subject(this.id);
}
