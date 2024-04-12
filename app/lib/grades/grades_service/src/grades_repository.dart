part of '../grades_service.dart';

class GradesRepository {
  IList<_Term> _terms = const IListConst<_Term>([]);
  void saveTerms(IList<_Term> terms) {
    _terms = terms;
  }

  IList<_Term> loadTerms() {
    return _terms;
  }

  IList<GradeType> _gradeTypes = const IListConst([]);
  void saveCustomGradeType(GradeType gradeType) {
    _gradeTypes = _gradeTypes.add(gradeType);
  }

  IList<GradeType> loadCustomGradeTypes() {
    return _gradeTypes;
  }

  IList<Subject> _subjects = const IListConst([]);
  void saveSubjects(IList<Subject> subjects) {
    _subjects = subjects;
  }

  IList<Subject> loadSubjects() {
    return _subjects;
  }
}
