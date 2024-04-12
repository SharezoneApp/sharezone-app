part of '../grades_service.dart';

typedef GradesState = ({
  IList<_Term> terms,
  IList<GradeType> customGradeTypes,
  IList<Subject> subjects
});

extension GradesStateCopyWith on GradesState {
  GradesState copyWith({
    IList<_Term>? terms,
    IList<GradeType>? customGradeTypes,
    IList<Subject>? subjects,
  }) {
    return (
      terms: terms ?? this.terms,
      customGradeTypes: customGradeTypes ?? this.customGradeTypes,
      subjects: subjects ?? this.subjects,
    );
  }
}

class GradesRepository {
  BehaviorSubject<GradesState> state = BehaviorSubject<GradesState>();

  GradesRepository() {
    updateState();
  }

  void updateState() {
    state.add((
      terms: _terms,
      customGradeTypes: _gradeTypes,
      subjects: _subjects,
    ));
  }

  IList<_Term> _terms = const IListConst<_Term>([]);
  void saveTerms(IList<_Term> terms) {
    _terms = terms;
    updateState();
  }

  IList<_Term> loadTerms() {
    return _terms;
  }

  IList<GradeType> _gradeTypes = const IListConst([]);
  void saveCustomGradeType(GradeType gradeType) {
    _gradeTypes = _gradeTypes.add(gradeType);
    updateState();
  }

  IList<GradeType> loadCustomGradeTypes() {
    return _gradeTypes;
  }

  IList<Subject> _subjects = const IListConst([]);
  void saveSubjects(IList<Subject> subjects) {
    _subjects = subjects;
    updateState();
  }

  IList<Subject> loadSubjects() {
    return _subjects;
  }
}
