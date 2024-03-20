import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:rxdart/subjects.dart' as rx;
import 'package:sharezone/grades/models/grade_id.dart';
import '../models/subject_id.dart';
import '../models/term_id.dart';

export '../models/grade_id.dart';
export '../models/subject_id.dart';
export '../models/term_id.dart';

part './src/term.dart';

class GradesService {
  final rx.BehaviorSubject<IList<TermResult>> terms;

  GradesService() : terms = rx.BehaviorSubject.seeded(const IListConst([]));

  IList<Term> _terms = const IListConst<Term>([]);

  void _updateTerm(Term term) {
    _terms = _terms.replaceAllWhere((t) => t.id == term.id, term);
    _updateTerms();
  }

  void _updateTerms() {
    final termRes = _terms
        .map((term) => TermResult(
              id: term.id,
              name: term.name,
              isActiveTerm: term.isActiveTerm,
              calculatedGrade: term.tryGetTermGrade(),
              subjects: term.subjects
                  .map(
                    (subject) => SubjectRes(
                      id: SubjectId(subject.id),
                      calculatedGrade: subject.gradeVal,
                      weightType: subject.weightType,
                      gradeTypeWeights: subject.gradeTypeWeights.map(
                          (key, value) => MapEntry(key, Weight.factor(value))),
                    ),
                  )
                  .toIList(),
            ))
        .toIList();
    terms.add(termRes);
  }

  void createTerm({
    required TermId id,
    required String name,
    required GradeType finalGradeType,
    required bool isActiveTerm,
  }) {
    if (isActiveTerm) {
      _terms = _terms.map((term) => term.setIsActiveTerm(false)).toIList();
    }

    _terms = _terms.add(
      Term(
        id: id,
        isActiveTerm: isActiveTerm,
        name: name,
        finalGradeType: finalGradeType,
      ),
    );
    _updateTerms();
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
  final SubjectId id;
  final num? calculatedGrade;
  final WeightType weightType;
  final IMap<GradeType, Weight> gradeTypeWeights;

  SubjectRes({
    required this.id,
    required this.calculatedGrade,
    required this.weightType,
    required this.gradeTypeWeights,
  });
}

class TermResult {
  final TermId id;
  final num? calculatedGrade;
  IList<SubjectRes> subjects;
  final bool isActiveTerm;
  final String name;

  SubjectRes subject(SubjectId id) {
    final subject = subjects.firstWhere((element) => element.id == id);
    return subject;
  }

  TermResult({
    required this.id,
    required this.name,
    required this.calculatedGrade,
    required this.subjects,
    required this.isActiveTerm,
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
