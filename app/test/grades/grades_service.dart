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

  void updateTerm(Term term) {
    _terms = _terms.replace(0, term);
    final termRes = _terms
        .map((term) => TermResult(
              term.tryGetTermGrade(),
              IMap.fromEntries(
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

  void createTerm({required TermId id}) {
    _terms = _terms.add(Term());
  }

  void addSubject({required SubjectId id, required TermId toTerm}) {
    final newTerm = _terms.single.addSubject(Subject(id.toString()));
    updateTerm(newTerm);
  }

  void changeSubjectWeightForTermGrade(
      {required SubjectId id, required TermId termId, required Weight weight}) {
    final newTerm = _terms.single
        .subject(id.toString())
        .changeWeightingForTermGrade(weight.asFactor);

    updateTerm(newTerm);
  }

  void changeSubjectWeightTypeSettings(
      {required SubjectId id,
      required TermId termId,
      required WeightType perGradeType}) {
    final newTerm =
        _terms.single.subject(id.toString()).changeWeightingType(perGradeType);
    updateTerm(newTerm);
  }

  void changeGradeTypeWeightForSubject({
    required SubjectId id,
    required TermId termId,
    required GradeType gradeType,
    required Weight weight,
  }) {
    final newTerm = _terms.single
        .subject(id.toString())
        .changeGradeTypeWeighting(gradeType,
            weight: weight.asFactor.toDouble());
    updateTerm(newTerm);
  }

  void addGrade({
    required SubjectId id,
    required TermId termId,
    required Grade value,
    bool takeIntoAccount = true,
  }) {
    final newTerm = _terms.single
        .subject(id.toString())
        .addGrade(value, takeIntoAccount: takeIntoAccount);
    updateTerm(newTerm);
  }

  void changeGradeWeight({
    required GradeId id,
    required TermId termId,
    required Weight weight,
  }) {
    final subject = _terms.single.subjects
        .where((element) => element.grades.any((grade) => grade.id == id))
        .first;
    final newTerm =
        subject.grade(id).changeWeight(weight: weight.asFactor.toDouble());

    updateTerm(newTerm);
  }

  void changeGradeTypeWeightForTerm(
      {required TermId termId,
      required GradeType gradeType,
      required Weight weight}) {
    final newTerm = _terms.single.changeWeightingOfGradeType(gradeType,
        weight: weight.asFactor.toDouble());
    updateTerm(newTerm);
  }
}
