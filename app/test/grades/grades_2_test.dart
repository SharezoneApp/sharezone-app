import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/privacy_policy/src/privacy_policy_src.dart';
import 'package:test_randomness/test_randomness.dart';

void main() {
  group('grades', () {
    test('the term grade of two different subjects in term', () {
      var term = Term();
      final englisch = Subject('Englisch');

      term = term.addSubject(englisch);
      term = term.subject(englisch.id).addGrade(gradeWith(value: 3.0));
      term = term.subject(englisch.id).addGrade(gradeWith(value: 1.0));
      expect(term.subject(englisch.id).gradeVal, 2.0);

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.subject(mathe.id).addGrade(gradeWith(value: 2.0));
      term = term.subject(mathe.id).addGrade(gradeWith(value: 4.0));

      expect(term.subject(mathe.id).gradeVal, 3.0);
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

      const weight1 = 0.5; // weight for English
      const weight2 = 1; // weight for Math
      const weight3 = 2; // weight for Computer Science

      const sumOfWeights = weight1 + weight2 + weight3;

      const expected = (3 * weight1 + 2 * weight2 + 1 * weight3) / sumOfWeights;
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
      expect(term.subject(englisch.id).gradeVal, 1.0);

      final mathe = Subject('Mathe');
      term = term.addSubject(mathe);
      term = term.subject(mathe.id).addGrade(gradeWith(value: 1.0));
      term = term
          .subject(mathe.id)
          .addGrade(gradeWith(value: 3.0), takeIntoAccount: false);
      expect(term.subject(mathe.id).gradeVal, 1.0);

      expect(term.getTermGrade(), 1.0);
    });

    test('subjects can have custom weights per grade type (e.g. presentation)',
        () {
      var term = Term();
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);

      term = term
          .subject(englisch.id)
          .changeWeightingType(WeightType.perGradeType);
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

      const weight1 = 0.7; // weight for presentation
      const weight2 = 1.5; // weight for exam
      const weight3 = 1; // default weight for vocabulary test

      const sumOfWeights = weight1 + weight2 + weight3;

      const expected = (2 * weight1 + 1 * weight2 + 1 * weight3) / sumOfWeights;
      expect(term.subject(englisch.id).gradeVal, expected);
    });
    test('subjects can have custom weights per grade', () {
      var term = Term();
      final englisch = Subject('Englisch');
      term = term.addSubject(englisch);

      final grade1 = gradeWith(value: 1.0);
      final grade2 = gradeWith(value: 4.0);
      final grade3 = gradeWith(value: 3.0);

      term = term.subject(englisch.id).addGrade(grade1);
      term = term.subject(englisch.id).addGrade(grade2);
      term = term.subject(englisch.id).addGrade(grade3);
      term = term.subject(englisch.id).changeWeightingType(WeightType.perGrade);

      term =
          term.subject(englisch.id).grade(grade1.id).changeWeight(weight: 0.2);
      term = term.subject(englisch.id).grade(grade2.id).changeWeight(weight: 2);
      // grade3 has the default weight of 1

      const weight1 = 0.2;
      const weight2 = 2;
      const weight3 = 1; // default weight

      const sumOfWeights = weight1 + weight2 + weight3;

      const expected = (1 * weight1 + 4 * weight2 + 3 * weight3) / sumOfWeights;
      expect(expected, closeTo(3.5, 0.01));
      expect(term.subject(englisch.id).gradeVal, expected);
    });
  });
}

enum WeightType { perGrade, perGradeType }

Grade gradeWith({
  required double value,
  GradeType type = const GradeType('testGradeType'),
}) {
  return Grade(id: GradeId(randomAlphaNumeric(5)), value: value, type: type);
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
    return _copyWith(
      subjects: _subjects.add(_Subject(
        id: subject.id,
        weightType: WeightType.perGradeType,
      )),
    );
  }

  SubjectResult subject(String id) {
    return _subjects
        .where((s) => s.id == id)
        .map(
          (subject) => SubjectResult(
            this,
            id: subject.id,
            gradeVal: subject.getGrade(),
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
    final gradedSubjects =
        _subjects.where((element) => element.getGrade() != null);
    return gradedSubjects
            .map((subject) =>
                subject.getGrade()! * subject.weightingForTermGrade)
            .reduce(
              (a, b) => a + b,
            ) /
        gradedSubjects
            .map((e) => e.weightingForTermGrade)
            .reduce((a, b) => a + b);
  }

  Term _addGrade(Grade grade,
      {required String toSubject, bool takenIntoAccount = true}) {
    var subject = _subjects.firstWhere((s) => s.id == toSubject,
        orElse: () =>
            _Subject(id: toSubject, weightType: WeightType.perGradeType));
    subject = subject.addGrade(_Grade(
      id: grade.id,
      value: grade.value,
      takenIntoAccount: takenIntoAccount,
      gradeType: grade.type,
      weight: 1,
    ));

    return _subjects.where((element) => element.id == toSubject).isNotEmpty
        ? _copyWith(
            subjects: _subjects.replaceAllWhere(
                (element) => element.id == toSubject, subject))
        : _copyWith(subjects: _subjects.add(subject));
  }

  Term _changeWeighting(String id, num newWeight) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
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

  Term _changeWeightOfGrade(GradeId id, String subjectId, double weight) {
    final subject = _subjects.firstWhere((s) => s.id == subjectId);
    final newSubject = subject.copyWith(
      grades: subject.grades.replaceFirstWhere(
        (g) => g.id == id,
        (g) => g!.copyWith(weight: weight),
      ),
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == subjectId, newSubject),
    );
  }

  Term changeWeightTypeForSubject(String id, WeightType weightType) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      weightType: weightType,
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }
}

class GradeId extends Id {
  GradeId(String id) : super(id, 'GradeId');
}

class Grade {
  final GradeId id;
  final num value;
  final GradeType type;

  Grade({
    required this.id,
    required this.value,
    this.type = const GradeType('testGradeType'),
  });
}

class SubjectResult {
  final Term _term;
  final String id;
  final num? gradeVal;

  SubjectResult(this._term, {required this.id, required this.gradeVal});

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

  GradeResult grade(GradeId id) {
    return GradeResult(_term, id: id, subjectId: this.id);
  }

  Term changeWeightingType(WeightType weightType) {
    return _term.changeWeightTypeForSubject(id, weightType);
  }
}

class GradeResult {
  final Term _term;
  final GradeId id;
  final String subjectId;

  GradeResult(this._term, {required this.id, required this.subjectId});

  Term changeWeight({required double weight}) {
    return _term._changeWeightOfGrade(id, subjectId, weight);
  }
}

class _Subject {
  final String id;
  final IList<_Grade> grades;
  final num weightingForTermGrade;
  final IMap<GradeType, double> gradeTypeWeightings;
  final WeightType weightType;

  _Subject({
    required this.id,
    required this.weightType,
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
            .map((grade) => grade.value * _weightFor(grade))
            .reduce((a, b) => a + b) /
        grds.map((e) => _weightFor(e)).reduce((a, b) => a + b);
  }

  num _weightFor(_Grade grade) {
    return switch (weightType) {
      WeightType.perGrade => grade.weight,
      WeightType.perGradeType => gradeTypeWeightings[grade.gradeType] ?? 1,
    };
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
    WeightType? weightType,
  }) {
    return _Subject(
      id: id ?? this.id,
      grades: grades ?? this.grades,
      weightingForTermGrade:
          weightingForTermGrade ?? this.weightingForTermGrade,
      gradeTypeWeightings: gradeTypeWeightings ?? this.gradeTypeWeightings,
      weightType: weightType ?? this.weightType,
    );
  }
}

class _Grade extends Equatable {
  final GradeId id;
  final num value;
  final GradeType gradeType;
  final bool takenIntoAccount;
  final num weight;

  @override
  List<Object?> get props => [id, value, gradeType, takenIntoAccount, weight];

  _Grade({
    required this.id,
    required this.value,
    required this.gradeType,
    required this.weight,
    this.takenIntoAccount = true,
  });

  _Grade copyWith({
    GradeId? id,
    num? value,
    GradeType? gradeType,
    bool? takenIntoAccount,
    num? weight,
  }) {
    return _Grade(
      id: id ?? this.id,
      value: value ?? this.value,
      gradeType: gradeType ?? this.gradeType,
      takenIntoAccount: takenIntoAccount ?? this.takenIntoAccount,
      weight: weight ?? this.weight,
    );
  }
}

class Subject {
  final String id;

  Subject(this.id);
}
