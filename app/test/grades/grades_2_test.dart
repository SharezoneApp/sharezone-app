import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('grades', () {
    test('the term grade of two different subjects in term', () {
      var term = Term();
      final englisch = Subject('Englisch');

      term = term.addSubject(englisch);
      term = term.subject(englisch.id).addGrade(gradeWith(value: 3.0));
      term = term.subject(englisch.id).addGrade(gradeWith(value: 1.0));
      expect(term.subject(englisch.id).grade, 2.0);

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.subject(mathe.id).addGrade(gradeWith(value: 2.0));
      term = term.subject(mathe.id).addGrade(gradeWith(value: 4.0));

      expect(term.subject(mathe.id).grade, 3.0);
    });

    test(
        'the term grade should equal the average of the average grades of every subject',
        () {
      var term = Term();
      final englisch = Subject('Englisch');

      term = term.addSubject(englisch);
      term = term.subject(englisch.id).addGrade(gradeWith(value: 3.0));
      term = term.subject(englisch.id).addGrade(gradeWith(value: 1.0));

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.subject(mathe.id).addGrade(gradeWith(value: 2.0));
      term = term.subject(mathe.id).addGrade(gradeWith(value: 4.0));

      expect(term.getTermGrade(), 2.5);
    });
    test(
        'the term grade should equal the average of the average grades of every subject taking weightings into account',
        () {
      var term = Term();
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);
      term = term.subject(englisch.id).addGrade(gradeWith(value: 3.0));

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.subject(mathe.id).addGrade(gradeWith(value: 2.0));

      final informatik = Subject('Informatik');
      term = term.addSubject(informatik);
      term = term.subject(informatik.id).addGrade(gradeWith(value: 1.0));

      term = term.subject(englisch.id).changeWeightingForTermGrade(0.5);
      term = term.subject(mathe.id).changeWeightingForTermGrade(1);
      term = term.subject(informatik.id).changeWeightingForTermGrade(2);

      const expected = (3 * (1 / 0.5) + 2 * (1 / 1) + 1 * (1 / 2)) / 3;
      expect(term.getTermGrade(), expected);
    });
    test(
        'one can add grades that are not taken into account for the term and subject grade',
        () {
      var term = Term();
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);
      term = term.subject(englisch.id).addGrade(gradeWith(value: 1.0));
      term = term
          .subject(englisch.id)
          .addGrade(gradeWith(value: 1.0), takeIntoAccount: false);
      expect(term.subject(englisch.id).grade, 1.0);

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.subject(mathe.id).addGrade(gradeWith(value: 1.0));
      term = term
          .subject(mathe.id)
          .addGrade(gradeWith(value: 3.0), takeIntoAccount: false);
      expect(term.subject(mathe.id).grade, 1.0);

      expect(term.getTermGrade(), 1.0);
    });

    test('subjects can have custom weights per grade type (e.g. presentation)',
        () {
      var term = Term();
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);
      term = term
          .subject(englisch.id)
          .addGrade(gradeWith(value: 2.0, type: GradeType('presentation')));
      term = term
          .subject(englisch.id)
          .addGrade(gradeWith(value: 1.0, type: GradeType('exam')));
      term = term
          .subject(englisch.id)
          .addGrade(gradeWith(value: 1.0, type: GradeType('vocabulary test')));
      term = term
          .subject(englisch.id)
          .changeGradeTypeWeighting(GradeType('presentation'), weight: 0.7);
      term = term
          .subject(englisch.id)
          .changeGradeTypeWeighting(GradeType('exam'), weight: 1.5);

      const expected = (2 * (1 / 0.7) + 1 * (1 / 1.5) + 1 * (1 / 1)) / 3;
      expect(term.subject(englisch.id).grade, expected);
    });
  });
}

Grade gradeWith({
  required double value,
  GradeType type = const GradeType('testGradeType'),
}) {
  return Grade(value: value, type: type);
}

class GradeType extends Equatable {
  final String id;

  @override
  List<Object?> get props => [id];

  const GradeType(this.id);
}

class Term {
  final IList<_Subject> _subjects;

  Term() : _subjects = const IListConst([]);
  Term.internal(this._subjects);

  Term addSubject(Subject subject) {
    return _copyWith(subjects: _subjects.add(_Subject(id: subject.id)));
  }

  SubjectResult subject(String id) {
    return _subjects
        .where((s) => s.id == id)
        .map(
          (subject) => SubjectResult(
            this,
            id: subject.id,
            grade: subject.getGrade(),
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
            .where((element) => element.getGrade() != null)
            .map((subject) =>
                subject.getGrade()! / subject.weightingForTermGrade)
            .reduce(
              (a, b) => a + b,
            ) /
        _subjects.length;
  }

  Term _addGrade(Grade grade,
      {required String toSubject, bool takenIntoAccount = true}) {
    var subject = _subjects.firstWhere((s) => s.id == toSubject,
        orElse: () => _Subject(id: toSubject));
    subject = subject.addGrade(_Grade(
      value: grade.value,
      takenIntoAccount: takenIntoAccount,
      gradeType: grade.type,
    ));

    return _subjects.where((element) => element.id == toSubject).isNotEmpty
        ? _copyWith(
            subjects: _subjects.replaceAllWhere(
                (element) => element.id == toSubject, subject))
        : _copyWith(subjects: _subjects.add(subject));
  }

  Term _changeWeighting(String id, num newWeight) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = _Subject(
      id: id,
      grades: subject.grades,
      weightingForTermGrade: newWeight,
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  Term _changeWeightingOfGradeTypeInSubject(
      String id, GradeType gradeType, double weight) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.changeGradeTypeWeight(gradeType, weight: weight);

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }
}

class Grade {
  final num value;
  final GradeType type;

  Grade({
    required this.value,
    this.type = const GradeType('testGradeType'),
  });
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

  Term changeWeightingForTermGrade(num newWeight) {
    return _term._changeWeighting(id, newWeight);
  }

  Term changeGradeTypeWeighting(GradeType gradeType, {required double weight}) {
    return _term._changeWeightingOfGradeTypeInSubject(id, gradeType, weight);
  }
}

class _Subject {
  final String id;
  final IList<_Grade> grades;
  final num weightingForTermGrade;
  final IMap<GradeType, double> gradeTypeWeightings;

  _Subject({
    required this.id,
    this.grades = const IListConst([]),
    this.weightingForTermGrade = 1,
    this.gradeTypeWeightings = const IMapConst({}),
  });

  _Subject addGrade(_Grade grade) {
    return copyWith(grades: grades.add(grade));
  }

  num? getGrade() {
    final grds = grades.where((grade) => grade.takenIntoAccount);
    if (grds.isEmpty) return null;

    return grds
            .map((grade) => grade.value * 1 / _weightFor(grade))
            .reduce((a, b) => a + b) /
        grds.length;
  }

  num _weightFor(_Grade grade) {
    return gradeTypeWeightings[grade.gradeType] ?? 1;
  }

  _Subject changeGradeTypeWeight(GradeType gradeType,
      {required double weight}) {
    return copyWith(
        gradeTypeWeightings: gradeTypeWeightings.add(gradeType, weight));
  }

  _Subject copyWith({
    String? id,
    IList<_Grade>? grades,
    num? weightingForTermGrade,
    IMap<GradeType, double>? gradeTypeWeightings,
  }) {
    return _Subject(
      id: id ?? this.id,
      grades: grades ?? this.grades,
      weightingForTermGrade:
          weightingForTermGrade ?? this.weightingForTermGrade,
      gradeTypeWeightings: gradeTypeWeightings ?? this.gradeTypeWeightings,
    );
  }
}

class _Grade {
  final num value;
  final GradeType gradeType;
  final bool takenIntoAccount;

  _Grade({
    required this.value,
    required this.gradeType,
    this.takenIntoAccount = true,
  });
}

class Subject {
  final String id;

  Subject(this.id);
}
