import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/subject_id.dart';
import 'package:sharezone/grades/term_id.dart';

void main() {
  group('grades', () {
    test('create two different terms and get average note', () {
      var firstTerm = termWith(name: '1. Halbjahr');
      final englisch = subjectWith(name: 'Englisch', withGrades: [
        gradeWith(value: 2),
      ]);
      final mathe = subjectWith(name: 'Mathe', withGrades: [
        gradeWith(value: 4),
      ]);
      firstTerm = firstTerm.addSubject(englisch);
      firstTerm = firstTerm.addSubject(mathe);

      final deutsch = subjectWith(name: 'Deutsch', withGrades: [
        gradeWith(value: 1),
      ]);
      final informatik = subjectWith(name: 'Informatik', withGrades: [
        gradeWith(value: 3),
      ]);

      var secondTerm = termWith(name: '2. Halbjahr');
      secondTerm = secondTerm.addSubject(deutsch);
      secondTerm = secondTerm.addSubject(informatik);

      expect(firstTerm.getAverageGrade(), 3);
      expect(secondTerm.getAverageGrade(), 2);
    });
  });
}

Term termWith({required String name}) {
  return Term(id: TermId(name), name: name);
}

class Term {
  final TermId id;
  final String name;
  IList<Subject> subjects;

  Term({
    required this.id,
    required this.name,
    this.subjects = const IListConst([]),
  });

  Term addSubject(Subject subject) {
    return copyWith(subjects: subjects.add(subject));
  }

  double getAverageGrade() {
    return subjects
            .map((subject) => subject.getAverageGrade())
            .reduce((a, b) => a + b) /
        subjects.length;
  }

  Term copyWith({
    TermId? id,
    String? name,
    IList<Subject>? subjects,
  }) {
    return Term(
      id: id ?? this.id,
      name: name ?? this.name,
      subjects: subjects ?? this.subjects,
    );
  }
}

class Subject {
  final SubjectId id;
  final String name;
  final List<Grade> grades;
  final TermId? termId;

  Subject({
    required this.id,
    required this.name,
    required this.grades,
    this.termId,
  });

  double getAverageGrade() {
    return grades.map((grade) => grade.value).reduce((a, b) => a + b) /
        grades.length;
  }

  Subject copyWith({
    SubjectId? id,
    String? name,
    List<Grade>? grades,
    TermId? termId,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      grades: grades ?? this.grades,
      termId: termId ?? this.termId,
    );
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
