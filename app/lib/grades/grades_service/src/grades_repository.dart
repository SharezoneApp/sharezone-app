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
  GradesState get _state => state.value;

  GradesRepository() {
    state.add((
      terms: const IListConst([]),
      customGradeTypes: const IListConst([]),
      subjects: const IListConst([]),
    ));
  }

  void updateState(GradesState state) {
    this.state.add(state);
  }

  void saveTerms(IList<_Term> terms) {
    updateState(_state.copyWith(terms: terms));
  }

  void saveCustomGradeTypes(IList<GradeType> gradeTypes) {
    updateState(_state.copyWith(customGradeTypes: gradeTypes));
  }

  void saveSubjects(IList<Subject> subjects) {
    updateState(_state.copyWith(subjects: subjects));
  }
}
