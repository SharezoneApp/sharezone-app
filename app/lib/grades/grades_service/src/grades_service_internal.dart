// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of '../grades_service.dart';

class _GradesServiceInternal {
  final rx.BehaviorSubject<IList<TermResult>> terms;
  final GradesStateRepository _repository;

  _GradesServiceInternal({GradesStateRepository? repository})
      : _repository = repository ?? InMemoryGradesStateRepository(),
        terms = rx.BehaviorSubject.seeded(const IListConst([])) {
    _repository.state.listen((state) {
      _updateView();
    });

    _updateView();
  }

  GradesState get _state => _repository.state.value;

  IList<TermModel> get _terms => _state.terms;

  IList<Subject> get _subjects => _state.subjects;

  IList<GradeType> get _customGradeTypes => _state.customGradeTypes;

  void _updateState(GradesState state) {
    _repository.updateState(state);
    // Removing this breaks our tests because they assume that the state is
    // updated synchronously. Usually calling [_updateView] in the .listen from
    // the repository would be enough.
    _updateView();
  }

  void _updateTerms(IList<TermModel> terms) {
    final newState = _state.copyWith(terms: terms);
    _updateState(newState);
  }

  void _updateView() {
    final termRes = _terms.map(_toTermResult).toIList();
    terms.add(termRes);
  }

  void _updateTerm(TermModel term) {
    final newTerms = _terms.replaceAllWhere((t) => t.id == term.id, term);
    _updateTerms(newTerms);
  }

  TermResult _toTermResult(TermModel term) {
    return TermResult(
      id: term.id,
      name: term.name,
      isActiveTerm: term.isActiveTerm,
      finalGradeType: _getGradeType(term.finalGradeType),
      gradingSystem: term.gradingSystem.toGradingSystem(),
      calculatedGrade: term.tryGetTermGrade() != null
          ? term.gradingSystem.toGradeResult(term.tryGetTermGrade()!)
          : null,
      gradeTypeWeightings: term.gradeTypeWeightings,
      weightDisplayType: term.weightDisplayType,
      subjects: term.subjects
          .map(
            (subject) => SubjectResult(
              id: subject.id,
              name: subject.name,
              design: subject.design,
              abbreviation: subject.abbreviation,
              connectedCourses: subject.connectedCourses,
              calculatedGrade: subject.gradeVal != null
                  ? subject.gradingSystem.toGradeResult(subject.gradeVal!)
                  : null,
              weightType: subject.weightType,
              gradeTypeWeights: subject.gradeTypeWeightings,
              finalGradeTypeId: subject.finalGradeType,
              weightingForTermGrade: subject.weightingForTermGrade,
              grades: subject.grades
                  .map(
                    (grade) => GradeResult(
                      id: grade.id,
                      date: grade.date,
                      isTakenIntoAccount: grade.takenIntoAccount,
                      value: grade.value,
                      title: grade.title,
                      gradeTypeId: grade.gradeType,
                      details: grade.details,
                      originalInput: grade.originalInput,
                    ),
                  )
                  .toIList(),
            ),
          )
          .toIList(),
    );
  }

  TermId addTerm({
    required String name,
    required GradeTypeId finalGradeType,
    required GradingSystem gradingSystem,
    required bool isActiveTerm,
    @visibleForTesting TermId? id,
  }) {
    final termId = id ?? TermId(Id.generate().value);

    IList<TermModel> newTerms = _terms;
    if (isActiveTerm) {
      newTerms = newTerms.map((term) => term.setIsActiveTerm(false)).toIList();
    }

    if (!_hasGradeTypeWithId(finalGradeType)) {
      throw GradeTypeNotFoundException(finalGradeType);
    }

    newTerms = newTerms.add(
      TermModel(
        id: termId,
        isActiveTerm: isActiveTerm,
        name: name,
        finalGradeType: finalGradeType,
        gradingSystem: gradingSystem.toGradingSystemModel(),
      ),
    );
    _updateTerms(newTerms);
    return termId;
  }

  /// Edits the given values of the term (does not edit if the value is null).
  ///
  /// If the term is set to being active, any active term will be set to
  /// inactive. If the term is set to being inactive, nothing will happen to the
  /// other terms.
  ///
  /// Throws [GradeTypeNotFoundException] if the given [finalGradeType] is not
  /// a valid grade type.
  ///
  /// Throws [ArgumentError] if the term with the given [id] does not exist.
  void editTerm({
    required TermId id,
    final bool? isActiveTerm,
    final String? name,
    final GradeTypeId? finalGradeType,
    final GradingSystem? gradingSystem,
  }) {
    IList<TermModel> newTerms = _terms;

    if (isActiveTerm != null) {
      newTerms = newTerms.map((term) {
        if (id == term.id) {
          return term.setIsActiveTerm(isActiveTerm);
        } else {
          // If the term that is edited is set to being active, all other terms
          // should be set to inactive.
          // If the term that is edited is set to being inactive, nothing should
          // happen to the other terms.
          return term.setIsActiveTerm(isActiveTerm ? false : term.isActiveTerm);
        }
      }).toIList();
    }
    if (name != null) {
      newTerms = newTerms
          .map((term) => term.id == id ? term.setName(name) : term)
          .toIList();
    }
    if (finalGradeType != null) {
      if (!_hasGradeTypeWithId(finalGradeType)) {
        throw GradeTypeNotFoundException(finalGradeType);
      }
      newTerms = newTerms
          .map((term) =>
              term.id == id ? term.setFinalGradeType(finalGradeType) : term)
          .toIList();
    }
    if (gradingSystem != null) {
      newTerms = newTerms
          .map((term) => term.id == id
              ? term.setGradingSystem(gradingSystem.toGradingSystemModel())
              : term)
          .toIList();
    }

    _updateTerms(newTerms);
  }

  /// Deletes the term with the given [id] any grades inside it.
  ///
  /// No subjects will be deleted.
  ///
  /// Throws [ArgumentError] if the term with the given [id] does not exist.
  void deleteTerm(TermId id) {
    IList<TermModel> newTerms = _terms;

    final termOrNull = newTerms.firstWhereOrNull((term) => term.id == id);
    if (termOrNull != null) {
      newTerms = _terms.remove(termOrNull);
      _updateTerms(newTerms);
      return;
    }
    throw ArgumentError("Can't delete term, unknown $TermId: '$id'.");
  }

  TermModel _term(TermId id) => _terms.singleWhere((term) => term.id == id);

  void changeSubjectWeightForTermGrade(
      {required SubjectId id, required TermId termId, required Weight weight}) {
    final subject = _getSubjectOrThrow(id);

    var newTerm = _term(termId);
    if (!newTerm.hasSubject(id)) {
      newTerm = newTerm.addSubject(subject);
    }

    newTerm = newTerm.changeWeighting(id, weight.toNonNegativeWeightOrThrow());
    _updateTerm(newTerm);
  }

  void changeSubjectWeightTypeSettings(
      {required SubjectId id,
      required TermId termId,
      required WeightType perGradeType}) {
    final newTerm = _term(termId).changeWeightTypeForSubject(id, perGradeType);
    _updateTerm(newTerm);
  }

  void changeGradeTypeWeightForSubject({
    required SubjectId id,
    required TermId termId,
    required GradeTypeId gradeType,
    required Weight weight,
  }) {
    final newTerm = _term(termId).changeWeightingOfGradeTypeInSubject(
        id, gradeType, weight.toNonNegativeWeightOrThrow());
    _updateTerm(newTerm);
  }

  void removeGradeTypeWeightForSubject({
    required SubjectId id,
    required TermId termId,
    required GradeTypeId gradeType,
  }) {
    final newTerm =
        _term(termId).removeWeightingOfGradeTypeInSubject(id, gradeType);
    _updateTerm(newTerm);
  }

  GradeId addGrade({
    required SubjectId subjectId,
    required TermId termId,
    required GradeInput value,
    @visibleForTesting GradeId? id,
  }) {
    final gradeId = id ?? GradeId(Id.generate().value);
    final grade = value.toGrade(gradeId);

    final subject = _getSubjectOrThrow(subjectId);
    if (!_hasGradeTypeWithId(value.type)) {
      throw GradeTypeNotFoundException(value.type);
    }

    if (_hasGradeWithId(gradeId)) {
      throw DuplicateGradeIdException(gradeId);
    }

    var newTerm = _term(termId);
    if (!newTerm.hasSubject(subjectId)) {
      newTerm = newTerm.addSubject(subject);
    }
    newTerm = newTerm.addGrade(grade, toSubject: subjectId);
    _updateTerm(newTerm);

    return gradeId;
  }

  /// Replaces an existing grade with [id] with the [newGrade].
  ///
  /// Throws [GradeNotFoundException] if no grade with the given [id] of
  /// [newGrade] exists.
  ///
  /// Throws [GradeTypeNotFoundException] if the grade type of [newGrade] does
  /// not exist.
  ///
  /// Throws [InvalidGradeValueException] if the [_Grade.value] of the
  /// [newGrade] is not valid for the [_Grade.gradingSystem] of the [newGrade].
  void editGrade(GradeId id, GradeInput newGrade) {
    final grade = newGrade.toGrade(id);

    if (!_hasGradeWithId(id)) {
      throw GradeNotFoundException(id);
    }
    if (!_hasGradeTypeWithId(newGrade.type)) {
      throw GradeTypeNotFoundException(newGrade.type);
    }

    final term = _terms.firstWhere((term) => term.containsGrade(id));
    final newTerm = term.replaceGrade(grade);

    _updateTerm(newTerm);
  }

  void deleteGrade(GradeId gradeId) {
    final term = _terms.firstWhereOrNull((term) => term.hasGrade(gradeId));
    if (term != null) {
      final newTerm = term.removeGrade(gradeId);
      _updateTerm(newTerm);
      return;
    }
    throw GradeNotFoundException(gradeId);
  }

  bool _hasGradeWithId(GradeId id) {
    return _terms.any((term) => term.hasGrade(id));
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
    final newTerm = _term(termId).changeWeightOfGrade(
        id, subject.id, weight.toNonNegativeWeightOrThrow());

    _updateTerm(newTerm);
  }

  void changeWeightDisplayTypeForTerm(
      {required TermId termId, required WeightDisplayType weightDisplayType}) {
    final newTerm = _term(termId).changeWeightDisplayType(weightDisplayType);
    _updateTerm(newTerm);
  }

  void changeGradeTypeWeightForTerm(
      {required TermId termId,
      required GradeTypeId gradeType,
      required Weight weight}) {
    final newTerm = _term(termId).changeWeightingOfGradeType(gradeType,
        weight: weight.toNonNegativeWeightOrThrow());
    _updateTerm(newTerm);
  }

  void removeGradeTypeWeightForTerm({
    required TermId termId,
    required GradeTypeId gradeType,
  }) {
    final newTerm = _term(termId).removeWeightingOfGradeType(gradeType);
    _updateTerm(newTerm);
  }

  void changeSubjectFinalGradeType({
    required SubjectId id,
    required TermId termId,
    required GradeTypeId? gradeType,
  }) {
    if (gradeType == null) {
      final newTerm = _term(termId).subjectInheritFinalGradeTypeFromTerm(id);
      return _updateTerm(newTerm);
    }
    final newTerm = _term(termId).setFinalGradeTypeForSubject(id, gradeType);
    _updateTerm(newTerm);
  }

  /// Returns the possible grades for the given grading system as strings.
  ///
  /// The strings are ordered from the best grade to the worst grade.
  ///
  /// For example the values for the grading system "1-6 with plus and minus"
  /// would be: `['1+', '1', '1-', '2+', [...] '5+', '5', '5-', '6']`
  PossibleGradesResult getPossibleGrades(GradingSystem gradingSystem) {
    final gs = gradingSystem.toGradingSystemModel();
    return gs.possibleGrades;
  }

  IList<GradeType> getPossibleGradeTypes() {
    return GradeType.predefinedGradeTypes.addAll(_customGradeTypes);
  }

  bool _hasGradeTypeWithId(GradeTypeId id) {
    return getPossibleGradeTypes().map((gt) => gt.id).contains(id);
  }

  /// Creates a custom grade type.
  ///
  /// If the grade type already exists, nothing will happen.
  GradeTypeId addCustomGradeType({
    required String displayName,
    @visibleForTesting GradeTypeId? id,
  }) {
    final gradeTypeId = id ?? GradeTypeId(Id.generate().value);
    final gradeType = GradeType(id: gradeTypeId, displayName: displayName);

    if (_hasGradeTypeWithId(gradeTypeId)) {
      // Already exists.
      return gradeTypeId;
    }

    final newState =
        _state.copyWith(customGradeTypes: _customGradeTypes.add(gradeType));
    _updateState(newState);

    return gradeTypeId;
  }

  /// Edits properties of a custom grade type.
  ///
  /// Throws [ArgumentError] if the [displayName] is empty.
  ///
  /// Throws [GradeTypeNotFoundException] if the grade type with the given [id]
  /// does not exist.
  ///
  /// Throws [ArgumentError] if the grade type with the given [id] is a
  /// predefined grade type.
  void editCustomGradeType(
      {required GradeTypeId id, required String displayName}) {
    if (displayName.isEmpty) {
      throw ArgumentError('The display name must not be empty.');
    }

    final isPredefinedGradeType =
        GradeType.predefinedGradeTypes.map((gt) => gt.id).contains(id);
    if (isPredefinedGradeType) {
      throw ArgumentError('Cannot edit a predefined grade type.');
    }
    if (!_hasGradeTypeWithId(id)) {
      throw GradeTypeNotFoundException(id);
    }

    final newCustomGradeTypes = _customGradeTypes.replaceAllWhere(
        (element) => element.id == id,
        GradeType(id: id, displayName: displayName));

    final newState = _state.copyWith(customGradeTypes: newCustomGradeTypes);
    _updateState(newState);
  }

  /// Deletes a custom grade type and removes it from all weight maps.
  ///
  /// A custom grade type can only be deleted if it is not assigned to any grade
  /// or as the final grade type of any term, otherwise a
  /// [GradeTypeStillAssignedException] is thrown.
  ///
  /// Throws [GradeTypeNotFoundException] if the grade type with the given [id]
  /// does not exist.
  ///
  /// Throws [ArgumentError] if the grade type with the given [id] is a
  /// predefined grade type.
  void deleteCustomGradeType(GradeTypeId id) {
    if (GradeType.predefinedGradeTypes.any((gt) => gt.id == id)) {
      throw ArgumentError('Cannot delete a predefined grade type.');
    }
    if (!_hasGradeTypeWithId(id)) {
      throw GradeTypeNotFoundException(id);
    }

    final anyGradeHasGradeTypeAssigned = _terms.any((term) => term.subjects
        .expand((subj) => subj.grades)
        .any((grade) => grade.gradeType == id));
    if (anyGradeHasGradeTypeAssigned) {
      throw GradeTypeStillAssignedException(id);
    }

    if (_terms.any((term) => term.finalGradeType == id)) {
      throw GradeTypeStillAssignedException(id);
    }

    final newTerms = _terms.map((term) {
      var newTerm = term.removeWeightingOfGradeType(id);
      for (var subject in newTerm.subjects) {
        subject = subject.removeGradeTypeWeight(id);
        newTerm = newTerm.replaceSubject(subject);
      }
      return newTerm;
    }).toIList();

    final newCustomGrades = _customGradeTypes.removeWhere((gt) => gt.id == id);

    final newState =
        _state.copyWith(terms: newTerms, customGradeTypes: newCustomGrades);
    _updateState(newState);
  }

  GradeType _getGradeType(GradeTypeId finalGradeType) {
    return getPossibleGradeTypes().firstWhere((gt) => gt.id == finalGradeType);
  }

  SubjectId addSubject(SubjectInput subjectInput,
      {@visibleForTesting SubjectId? id}) {
    final subjectId = id ?? SubjectId(Id.generate().value);
    final subject = subjectInput.toSubject(subjectId);

    if (subject.createdOn != null) {
      throw ArgumentError(
          'The createdOn field should not be set when adding a new subject.');
    }
    if (getSubjects().any((s) => s.id == subjectId)) {
      throw SubjectAlreadyExistsException(subjectId);
    }
    final newState = _state.copyWith(subjects: _subjects.add(subject));
    _updateState(newState);

    return subjectId;
  }

  IList<Subject> getSubjects() {
    return _subjects;
  }

  Subject? getSubject(SubjectId id) {
    return getSubjects().firstWhereOrNull((subject) => subject.id == id);
  }

  Subject _getSubjectOrThrow(SubjectId id) {
    final sub = getSubject(id);
    if (sub == null) {
      throw SubjectNotFoundException(id);
    }
    return sub;
  }
}
