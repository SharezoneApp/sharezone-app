import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/subject_id.dart';
import 'package:sharezone/grades/term_id.dart';

void main() {
  group('grades', () {
    test('test name', () {
      final controller = GradesTestController();

      final term = termWith(name: '1. Halbjahr');
      controller.addTerm(term);

      final englisch = subjectWith(name: 'Englisch', withGrades: [
        gradeWith(value: 2),
        gradeWith(value: 3),
        gradeWith(value: 1),
      ]);

      controller.addSubjectToTerm(englisch, term.id);

      expect(controller.getAverageGradeForSubject(englisch.id), 2.0);
    });

    test('term', () {
      final controller = GradesTestController();

      final term = termWith(name: '1. Halbjahr');
      controller.addTerm(term);

      final englisch = subjectWith(name: 'Englisch', withGrades: [
        gradeWith(value: 2),
        gradeWith(value: 4),
      ]);

      final mathe = subjectWith(name: 'Mathe', withGrades: [
        gradeWith(value: 1),
        gradeWith(value: 3),
      ]);

      controller.addSubjectToTerm(englisch, term.id);
      controller.addSubjectToTerm(mathe, term.id);

      expect(controller.getAverageGradeWithAllSubjects(term.id), 2.5);
    });

    test('create two different terms and get average note', () {
      final controller = GradesTestController();

      final firstTerm = termWith(name: '1. Halbjahr');
      final secondTerm = termWith(name: '2. Halbjahr');

      controller.addTerm(firstTerm);
      controller.addTerm(secondTerm);

      final englisch = subjectWith(name: 'Englisch', withGrades: [
        gradeWith(value: 2),
      ]);

      final mathe = subjectWith(name: 'Mathe', withGrades: [
        gradeWith(value: 4),
      ]);

      controller.addSubjectToTerm(englisch, firstTerm.id);
      controller.addSubjectToTerm(mathe, firstTerm.id);

      final deutsch = subjectWith(name: 'Deutsch', withGrades: [
        gradeWith(value: 1),
      ]);
      final informatik = subjectWith(name: 'Informatik', withGrades: [
        gradeWith(value: 3),
      ]);

      controller.addSubjectToTerm(deutsch, secondTerm.id);
      controller.addSubjectToTerm(informatik, secondTerm.id);

      expect(controller.getAverageGradeWithAllSubjects(firstTerm.id), 3);
      expect(controller.getAverageGradeWithAllSubjects(secondTerm.id), 2);
    });
  });
}

class GradesTestController {
  final List<Subject> _subjects = [];
  List<Term> _terms = [];

  void addSubject(Subject subject) {
    _subjects.add(subject);
  }

  double getAverageGradeForSubject(SubjectId id) {
    final subject = _subjects.firstWhere((subject) => subject.id == id);
    return subject.getAverageGrade();
  }

  Term getTerm(TermId id) {
    return _terms.firstWhere((term) => term.id == id);
  }

  num getAverageGradeWithAllSubjects(TermId termId) {
    final _term = getTerm(termId);

    return _term.getAverageGrade();
  }

  void addSubjectToTerm(Subject subject, TermId id) {
    final term = _terms.where((term) => term.id == id).first;
    final subjectWithTerm = subject.copyWith(termId: id);
    term.addSubject(subjectWithTerm);

    addSubject(subjectWithTerm);
  }

  void addTerm(Term term) {
    _terms.add(term);
  }
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

  void addSubject(Subject subject) {
    subjects = subjects.add(subject);
  }

  double getAverageGrade() {
    return subjects
            .map((subject) => subject.getAverageGrade())
            .reduce((a, b) => a + b) /
        subjects.length;
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
