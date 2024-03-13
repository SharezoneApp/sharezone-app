import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('grades', () {
    test('the term grade of two different subjects in term', () {
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
        'the term grade should equal the average of the average grades of every subject',
        () {
      var term = Term();
      final englisch = Subject('Englisch');

      term = term.addGrade(3.0, toSubject: englisch.id);
      term = term.addGrade(1.0, toSubject: englisch.id);

      final mathe = Subject('Mathe');
      term = term.addGrade(2.0, toSubject: mathe.id);
      term = term.addGrade(4.0, toSubject: mathe.id);

      expect(term.getTermGrade(), 2.5);
    });
    test(
        'the term grade should equal the average of the average grades of every subject taking weightings into account',
        () {
      var term = Term();
      final englisch = Subject('Englisch');
      term = term.addGrade(3.0, toSubject: englisch.id);

      final mathe = Subject('Mathe');
      term = term.addGrade(2.0, toSubject: mathe.id);

      final informatik = Subject('Informatik');
      term = term.addGrade(1.0, toSubject: informatik.id);

      term = term.changeWeighting(englisch.id, 0.5);
      term = term.changeWeighting(mathe.id, 1);
      term = term.changeWeighting(informatik.id, 2);

      const expected = (3 * (1 / 0.5) + 2 * (1 / 1) + 1 * (1 / 2)) / 3;
      expect(term.getTermGrade(), expected);
    });
    test(
        'one can add grades that are not taken into account for the term and subject grade',
        () {
      var term = Term();
      final englisch = Subject('Englisch');
      term = term.addGrade(1.0, toSubject: englisch.id);
      term =
          term.addGrade(2.0, toSubject: englisch.id, takenIntoAccount: false);
      expect(term.getAverageGradeForSubject(englisch.id), 1.0);

      final mathe = Subject('Mathe');
      term = term.addGrade(1.0, toSubject: mathe.id);
      term = term.addGrade(3.0, toSubject: mathe.id, takenIntoAccount: false);
      expect(term.getAverageGradeForSubject(mathe.id), 1.0);

      expect(term.getTermGrade(), 1.0);
    });
  });
}

class Term {
  final IList<_Subject> _subjects;

  Term() : _subjects = const IListConst([]);
  Term.internal(this._subjects);

  Term addGrade(double grade,
      {required String toSubject, bool takenIntoAccount = true}) {
    var subject = _subjects.firstWhere((s) => s.id == toSubject,
        orElse: () => _Subject(id: toSubject));
    subject = subject
        .addGrade(_Grade(value: grade, takenIntoAccount: takenIntoAccount));

    return _subjects.where((element) => element.id == toSubject).isNotEmpty
        ? _copyWith(
            subjects: _subjects.replaceAllWhere(
                (element) => element.id == toSubject, subject))
        : _copyWith(subjects: _subjects.add(subject));
  }

  num getAverageGradeForSubject(String id) {
    return _subjects.firstWhere((s) => s.id == id).getAverageGrade();
  }

  Term _copyWith({
    IList<_Subject>? subjects,
  }) {
    return Term.internal(subjects ?? _subjects);
  }

  num getTermGrade() {
    return _subjects
            .map((subject) => subject.getAverageGrade() / subject.weighting)
            .reduce(
              (a, b) => a + b,
            ) /
        _subjects.length;
  }

  Term changeWeighting(String id, num newWeight) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = _Subject(
      id: id,
      grades: subject.grades,
      weighting: newWeight,
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }
}

class _Subject {
  final String id;
  final IList<_Grade> grades;
  final num weighting;

  _Subject({
    required this.id,
    this.grades = const IListConst([]),
    this.weighting = 1,
  });

  _Subject addGrade(_Grade grade) {
    return _Subject(
      id: id,
      grades: grades.add(grade),
    );
  }

  num getAverageGrade() {
    final grds = grades.where((grade) => grade.takenIntoAccount);

    return grds.map((grade) => grade.value).reduce((a, b) => a + b) /
        grds.length;
  }
}

class _Grade {
  final num value;
  final bool takenIntoAccount;

  _Grade({required this.value, this.takenIntoAccount = true});
}

class Subject {
  final String id;

  Subject(this.id);
}
