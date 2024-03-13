import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('grades', () {
    test('get average grade of two different subjects in term', () {
      var term = Term();
      final englisch = Subject('Englisch');

      term = term.addSubject(englisch);
      term = term.addGrade(3.0, toSubject: englisch.id);
      term = term.addGrade(1.0, toSubject: englisch.id);

      expect(term.getAverageGradeForSubject(englisch.id), 2.0);

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.addGrade(2.0, toSubject: mathe.id);
      term = term.addGrade(4.0, toSubject: mathe.id);

      expect(term.getAverageGradeForSubject(mathe.id), 3.0);
    });
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

  Term addSubject(Subject subject) {
    return this;
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
}

class Subject {
  final String id;

  Subject(this.id);
}
