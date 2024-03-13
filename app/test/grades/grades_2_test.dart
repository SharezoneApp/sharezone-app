import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('grades', () {
    test('the term grade of two different subjects in term', () {
      var term = Term();
      final englisch = Subject('Englisch');

      term = term.addSubject(englisch);
      term = term.getSubject(englisch.id).addGrade(Grade(value: 3.0));
      term = term.getSubject(englisch.id).addGrade(Grade(value: 1.0));
      expect(term.getSubject(englisch.id).grade, 2.0);

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.getSubject(mathe.id).addGrade(Grade(value: 2.0));
      term = term.getSubject(mathe.id).addGrade(Grade(value: 4.0));

      expect(term.getSubject(mathe.id).grade, 3.0);
    });

    test(
        'the term grade should equal the average of the average grades of every subject',
        () {
      var term = Term();
      final englisch = Subject('Englisch');

      term = term.addSubject(englisch);
      term = term.getSubject(englisch.id).addGrade(Grade(value: 3.0));
      term = term.getSubject(englisch.id).addGrade(Grade(value: 1.0));

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.getSubject(mathe.id).addGrade(Grade(value: 2.0));
      term = term.getSubject(mathe.id).addGrade(Grade(value: 4.0));

      expect(term.getTermGrade(), 2.5);
    });
    test(
        'the term grade should equal the average of the average grades of every subject taking weightings into account',
        () {
      var term = Term();
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);
      term = term.getSubject(englisch.id).addGrade(Grade(value: 3.0));

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.getSubject(mathe.id).addGrade(Grade(value: 2.0));

      final informatik = Subject('Informatik');
      term = term.addSubject(informatik);
      term = term.getSubject(informatik.id).addGrade(Grade(value: 1.0));

      term = term.getSubject(englisch.id).changeWeighting(0.5);
      term = term.getSubject(mathe.id).changeWeighting(1);
      term = term.getSubject(informatik.id).changeWeighting(2);

      const expected = (3 * (1 / 0.5) + 2 * (1 / 1) + 1 * (1 / 2)) / 3;
      expect(term.getTermGrade(), expected);
    });
    test(
        'one can add grades that are not taken into account for the term and subject grade',
        () {
      var term = Term();
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);
      term = term.getSubject(englisch.id).addGrade(Grade(value: 1.0));
      term = term
          .getSubject(englisch.id)
          .addGrade(Grade(value: 1.0), takeIntoAccount: false);
      expect(term.getSubject(englisch.id).grade, 1.0);

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.getSubject(mathe.id).addGrade(Grade(value: 1.0));
      term = term
          .getSubject(mathe.id)
          .addGrade(Grade(value: 3.0), takeIntoAccount: false);
      expect(term.getSubject(mathe.id).grade, 1.0);

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

  Term _addGrade(Grade grade,
      {required String toSubject, bool takenIntoAccount = true}) {
    var subject = _subjects.firstWhere((s) => s.id == toSubject,
        orElse: () => _Subject(id: toSubject));
    subject = subject.addGrade(
        _Grade(value: grade.value, takenIntoAccount: takenIntoAccount));

    return _subjects.where((element) => element.id == toSubject).isNotEmpty
        ? _copyWith(
            subjects: _subjects.replaceAllWhere(
                (element) => element.id == toSubject, subject))
        : _copyWith(subjects: _subjects.add(subject));
  }

  SubjectResult getSubject(String id) {
    return _subjects
        .where((s) => s.id == id)
        .map(
          (subject) => SubjectResult(
            this,
            id: subject.id,
            grade: subject.getAverageGrade(),
          ),
        )
        .first;
  }

  Term _copyWith({
    IList<_Subject>? subjects,
  }) {
    return Term.internal(subjects ?? _subjects);
  }

  num getTermGrade() {
    return _subjects
            .where((element) => element.getAverageGrade() != null)
            .map((subject) => subject.getAverageGrade()! / subject.weighting)
            .reduce(
              (a, b) => a + b,
            ) /
        _subjects.length;
  }

  Term _changeWeighting(String id, num newWeight) {
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

  Term addSubject(Subject subject) {
    return _copyWith(subjects: _subjects.add(_Subject(id: subject.id)));
  }
}

class Grade {
  final num value;

  Grade({required this.value});
}

class SubjectResult {
  final Term _term;
  final String id;
  final num? grade;

  SubjectResult(this._term, {required this.id, required this.grade});

  Term addGrade(Grade grade, {bool takeIntoAccount = true}) {
    return _term._addGrade(grade,
        toSubject: id, takenIntoAccount: takeIntoAccount);
  }

  Term changeWeighting(num newWeight) {
    return _term._changeWeighting(id, newWeight);
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

  num? getAverageGrade() {
    final grds = grades.where((grade) => grade.takenIntoAccount);
    if (grds.isEmpty) return null;

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
