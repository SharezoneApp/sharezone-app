import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:rxdart/subjects.dart' as rx;
import 'package:sharezone/grades/subject_id.dart';
import 'package:sharezone/grades/term_id.dart';

import 'grades_2_test.dart';
import 'grades_test.dart';

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
