import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:rxdart/subjects.dart' as rx;
import 'package:sharezone/grades/grade_id.dart';
import 'package:sharezone/grades/subject_id.dart';
import 'package:sharezone/grades/term_id.dart';

export 'grade_id.dart';
export 'subject_id.dart';
export 'term_id.dart';

class GradesService {
  final rx.BehaviorSubject<IList<TermResult>> terms;

  GradesService() : terms = rx.BehaviorSubject.seeded(const IListConst([]));

  IList<Term> _terms = const IListConst<Term>([]);

  void _updateTerm(Term term) {
    _terms = _terms.replaceAllWhere((t) => t.id == term.id, term);
    final termRes = _terms
        .map((term) => TermResult(
              id: term.id,
              calculatedGrade: term.tryGetTermGrade(),
              subjects: IMap.fromEntries(
                term.subjects.map(
                  (subject) => MapEntry(
                    SubjectId(subject.id),
                    SubjectRes(
                      calculatedGrade: subject.gradeVal,
                      weightType: subject.weightType,
                      gradeTypeWeights: subject.gradeTypeWeights.map(
                          (key, value) => MapEntry(key, Weight.factor(value))),
                    ),
                  ),
                ),
              ),
            ))
        .toIList();
    terms.add(termRes);
  }

  void createTerm({
    required TermId id,
    required GradeType finalGradeType,
  }) {
    _terms = _terms.add(Term(id: id).setFinalGradeType(finalGradeType));
  }

  Term _term(TermId id) => _terms.singleWhere((term) => term.id == id);

  void addSubject({required SubjectId id, required TermId toTerm}) {
    final newTerm = _term(toTerm).addSubject(Subject(id.toString()));
    _updateTerm(newTerm);
  }

  void changeSubjectWeightForTermGrade(
      {required SubjectId id, required TermId termId, required Weight weight}) {
    final newTerm = _term(termId)
        .subject(id.toString())
        .changeWeightingForTermGrade(weight.asFactor);

    _updateTerm(newTerm);
  }

  void changeSubjectWeightTypeSettings(
      {required SubjectId id,
      required TermId termId,
      required WeightType perGradeType}) {
    final newTerm =
        _term(termId).subject(id.toString()).changeWeightingType(perGradeType);
    _updateTerm(newTerm);
  }

  void changeGradeTypeWeightForSubject({
    required SubjectId id,
    required TermId termId,
    required GradeType gradeType,
    required Weight weight,
  }) {
    final newTerm = _term(termId)
        .subject(id.toString())
        .changeGradeTypeWeighting(gradeType,
            weight: weight.asFactor.toDouble());
    _updateTerm(newTerm);
  }

  void addGrade({
    required SubjectId id,
    required TermId termId,
    required Grade value,
    bool takeIntoAccount = true,
  }) {
    final newTerm = _term(termId)
        .subject(id.toString())
        .addGrade(value, takeIntoAccount: takeIntoAccount);
    _updateTerm(newTerm);
  }

  void changeGradeWeight({
    required GradeId id,
    required TermId termId,
    required Weight weight,
  }) {
    final subject = _term(termId)
        .subjects
        .where((element) => element.grades.any((grade) => grade.id == id))
        .first;
    final newTerm =
        subject.grade(id).changeWeight(weight: weight.asFactor.toDouble());

    _updateTerm(newTerm);
  }

  void changeGradeTypeWeightForTerm(
      {required TermId termId,
      required GradeType gradeType,
      required Weight weight}) {
    final newTerm = _term(termId).changeWeightingOfGradeType(gradeType,
        weight: weight.asFactor.toDouble());
    _updateTerm(newTerm);
  }

  void changeSubjectFinalGradeType({
    required SubjectId id,
    required TermId termId,
    required GradeType? gradeType,
  }) {
    if (gradeType == null) {
      final newTerm =
          _term(termId).subject(id.toString()).inheritFinalGradeTypeFromTerm();
      return _updateTerm(newTerm);
    }
    final newTerm =
        _term(termId).subject(id.toString()).changeFinalGradeType(gradeType);
    _updateTerm(newTerm);
  }
}

class SubjectRes {
  final num? calculatedGrade;
  final WeightType weightType;
  final IMap<GradeType, Weight> gradeTypeWeights;

  SubjectRes({
    required this.calculatedGrade,
    required this.weightType,
    required this.gradeTypeWeights,
  });
}

class TermResult {
  final TermId id;
  final num? calculatedGrade;
  IMap<SubjectId, SubjectRes> subjects;

  SubjectRes subject(SubjectId id) {
    final subject = subjects.get(id)!;
    return SubjectRes(
      calculatedGrade: subject.calculatedGrade,
      weightType: subject.weightType,
      gradeTypeWeights: subject.gradeTypeWeights,
    );
  }

  TermResult({
    required this.id,
    required this.calculatedGrade,
    required this.subjects,
  });
}

class SubjectResult {
  final Term _term;
  final String id;
  final num? gradeVal;
  final WeightType weightType;
  final IMap<GradeType, double> gradeTypeWeights;
  final IList<GradeResult> grades;

  SubjectResult(
    this._term, {
    required this.grades,
    required this.id,
    required this.gradeVal,
    required this.weightType,
    required this.gradeTypeWeights,
  });

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
    return grades.firstWhere((element) => element.id == id);
  }

  Term changeWeightingType(WeightType weightType) {
    return _term.changeWeightTypeForSubject(id, weightType);
  }

  Term changeFinalGradeType(GradeType gradeType) {
    return _term._setFinalGradeTypeForSubject(id, gradeType);
  }

  Term inheritFinalGradeTypeFromTerm() {
    return _term._subjectInheritFinalGradeTypeFromTerm(id);
  }
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

class GradeResult {
  final Term _term;
  final GradeId id;
  final num value;
  final GradeType type;
  final String subjectId;

  GradeResult(
    this._term, {
    required this.id,
    required this.subjectId,
    required this.value,
    required this.type,
  });

  Term changeWeight({required double weight}) {
    return _term._changeWeightOfGrade(id, subjectId, weight);
  }
}

enum WeightType { perGrade, perGradeType, inheritFromTerm }

class GradeType extends Equatable {
  final String id;

  @override
  List<Object?> get props => [id];

  const GradeType(this.id);
}

class Subject {
  final String id;

  Subject(this.id);
}

class Weight extends Equatable {
  final num asFactor;
  num get asPercentage => asFactor * 100;
  @override
  List<Object?> get props => [asFactor];

  const Weight.percent(num percent) : asFactor = percent / 100;
  const Weight.factor(this.asFactor);

  @override
  String toString() {
    return 'Weight($asFactor / $asPercentage%)';
  }
}

class Term {
  final TermId id;
  final IList<_Subject> _subjects;
  final IMap<GradeType, double> _gradeTypeWeightings;
  final GradeType _finalGradeType;
  IList<SubjectResult> get subjects {
    return _subjects.map(_toResult).toIList();
  }

  Term({required this.id})
      : _subjects = const IListConst([]),
        _gradeTypeWeightings = const IMapConst({}),
        _finalGradeType = const GradeType('zeugnisnote');

  Term.internal(
      this.id, this._subjects, this._gradeTypeWeightings, this._finalGradeType);

  Term addSubject(Subject subject) {
    return _copyWith(
      subjects: _subjects.add(_newSubject(subject.id)),
    );
  }

  _Subject _newSubject(String id) {
    return _Subject(
      id: id,
      finalGradeType: _finalGradeType,
      weightType: WeightType.inheritFromTerm,
      gradeTypeWeightingsFromTerm: _gradeTypeWeightings,
    );
  }

  SubjectResult _toResult(_Subject subject) => SubjectResult(
        this,
        gradeTypeWeights: subject.gradeTypeWeightings,
        grades: subject.grades
            .map(
              (grade) => GradeResult(
                this,
                id: grade.id,
                subjectId: subject.id,
                value: grade.value,
                type: grade.gradeType,
              ),
            )
            .toIList(),
        id: subject.id,
        gradeVal: subject.getGrade(),
        weightType: subject.weightType,
      );

  SubjectResult subject(String id) {
    return _subjects.where((s) => s.id == id).map(_toResult).first;
  }

  Term _copyWith({
    TermId? id,
    IList<_Subject>? subjects,
    IMap<GradeType, double>? gradeTypeWeightings,
    GradeType? finalGradeType,
  }) {
    return Term.internal(
      id ?? this.id,
      subjects ?? _subjects,
      gradeTypeWeightings ?? _gradeTypeWeightings,
      finalGradeType ?? _finalGradeType,
    );
  }

  num? tryGetTermGrade() {
    try {
      return getTermGrade();
    } catch (e) {
      return null;
    }
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

  Term changeWeightTypeForSubject(String id, WeightType weightType) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      weightType: weightType,
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  Term changeWeightingOfGradeType(GradeType type, {required num weight}) {
    final newWeights = _gradeTypeWeightings.add(type, weight.toDouble());
    final newSubjects = _subjects.map((s) {
      final newSubject = s.copyWith(gradeTypeWeightingsFromTerm: newWeights);
      return newSubject;
    }).toIList();

    return _copyWith(subjects: newSubjects, gradeTypeWeightings: newWeights);
  }

  Term setFinalGradeType(GradeType gradeType) {
    final newSubjects =
        _subjects.where((s) => s.isFinalGradeTypeOverridden == false).map((s) {
      final newSubject = s.copyWith(finalGradeType: gradeType);
      return newSubject;
    }).toIList();

    return _copyWith(finalGradeType: gradeType, subjects: newSubjects);
  }

  Term _addGrade(Grade grade,
      {required String toSubject, bool takenIntoAccount = true}) {
    var subject = _subjects.firstWhere(
      (s) => s.id == toSubject,
      orElse: () => _newSubject(toSubject),
    );
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

  Term _setFinalGradeTypeForSubject(String id, GradeType gradeType) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.overrideFinalGradeType(gradeType);

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }

  Term _subjectInheritFinalGradeTypeFromTerm(String id) {
    final subject = _subjects.firstWhere((s) => s.id == id);
    final newSubject = subject.copyWith(
      finalGradeType: _finalGradeType,
      isFinalGradeTypeOverridden: false,
    );

    return _copyWith(
      subjects: _subjects.replaceAllWhere((s) => s.id == id, newSubject),
    );
  }
}

class _Subject {
  final String id;
  final IList<_Grade> grades;
  final GradeType finalGradeType;
  final bool isFinalGradeTypeOverridden;
  final num weightingForTermGrade;
  final IMap<GradeType, double> gradeTypeWeightings;
  final IMap<GradeType, double> gradeTypeWeightingsFromTerm;
  final WeightType weightType;

  _Subject({
    required this.id,
    required this.weightType,
    required this.finalGradeType,
    this.isFinalGradeTypeOverridden = false,
    this.grades = const IListConst([]),
    this.weightingForTermGrade = 1,
    this.gradeTypeWeightings = const IMapConst({}),
    this.gradeTypeWeightingsFromTerm = const IMapConst({}),
  });

  _Subject addGrade(_Grade grade) {
    return copyWith(grades: grades.add(grade));
  }

  num? getGrade() {
    final grds = grades.where((grade) => grade.takenIntoAccount);
    if (grds.isEmpty) return null;

    final finalGrade =
        grds.where((grade) => grade.gradeType == finalGradeType).firstOrNull;
    if (finalGrade != null) return finalGrade.value;

    return grds
            .map((grade) => grade.value * _weightFor(grade))
            .reduce((a, b) => a + b) /
        grds.map((e) => _weightFor(e)).reduce((a, b) => a + b);
  }

  num _weightFor(_Grade grade) {
    return switch (weightType) {
      WeightType.perGrade => grade.weight,
      WeightType.perGradeType => gradeTypeWeightings[grade.gradeType] ?? 1,
      WeightType.inheritFromTerm =>
        gradeTypeWeightingsFromTerm[grade.gradeType] ?? 1,
    };
  }

  _Subject changeGradeTypeWeight(GradeType gradeType,
      {required double weight}) {
    return copyWith(
        gradeTypeWeightings: gradeTypeWeightings.add(gradeType, weight));
  }

  _Subject overrideFinalGradeType(GradeType gradeType) {
    return copyWith(
        finalGradeType: gradeType, isFinalGradeTypeOverridden: true);
  }

  _Subject copyWith({
    String? id,
    IList<_Grade>? grades,
    GradeType? finalGradeType,
    bool? isFinalGradeTypeOverridden,
    num? weightingForTermGrade,
    IMap<GradeType, double>? gradeTypeWeightings,
    IMap<GradeType, double>? gradeTypeWeightingsFromTerm,
    WeightType? weightType,
  }) {
    return _Subject(
      id: id ?? this.id,
      grades: grades ?? this.grades,
      finalGradeType: finalGradeType ?? this.finalGradeType,
      isFinalGradeTypeOverridden:
          isFinalGradeTypeOverridden ?? this.isFinalGradeTypeOverridden,
      weightingForTermGrade:
          weightingForTermGrade ?? this.weightingForTermGrade,
      gradeTypeWeightings: gradeTypeWeightings ?? this.gradeTypeWeightings,
      weightType: weightType ?? this.weightType,
      gradeTypeWeightingsFromTerm:
          gradeTypeWeightingsFromTerm ?? this.gradeTypeWeightingsFromTerm,
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
