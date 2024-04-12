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

abstract class GradesStateRepository {
  BehaviorSubject<GradesState> get state;
  void updateState(GradesState state);
}

class InMemoryGradesStateRepository extends GradesStateRepository {
  @override
  BehaviorSubject<GradesState> state = BehaviorSubject<GradesState>();

  InMemoryGradesStateRepository() {
    state.add((
      terms: const IListConst([]),
      customGradeTypes: const IListConst([]),
      subjects: const IListConst([]),
    ));
  }

  @override
  void updateState(GradesState state) {
    this.state.add(state);
  }
}
