// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:analytics/analytics.dart';
import 'package:collection/collection.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:date/date.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

import 'grades_dialog_view.dart';

class GradesDialogController extends ChangeNotifier {
  final Stream<List<Course>> coursesStream;
  final GradesService gradesService;
  final CrashAnalytics crashAnalytics;
  late StreamSubscription<List<Course>> _coursesStreamSubscription;
  late StreamSubscription<IList<TermResult>> _termsStreamSubscription;
  final Analytics analytics;

  GradesDialogView get view {
    final subject = _selectSubjectId != null
        ? _subjects.singleWhere((s) => s.id == _selectSubjectId)
        : null;
    final terms = gradesService.terms.value;
    final term = _selectedTermId != null
        ? terms.firstWhere((t) => t.id == _selectedTermId)
        : null;

    final termSub =
        term?.subjects.firstWhereOrNull((s) => s.id == _selectSubjectId);

    Weight? getWeightFor(GradeTypeId gradeTypeId) {
      if (term == null) return null;
      if (subject == null) return null;
      if (termSub == null) {
        // Default weights (50%/50%) for a new term
        if (gradeTypeId != GradeType.writtenExam.id &&
            gradeTypeId != GradeType.oralParticipation.id) {
          return Weight.zero;
        }
        return null;
      }

      return switch (termSub.weightType) {
        WeightType.inheritFromTerm => term.gradeTypeWeightings.isNotEmpty
            ? term.gradeTypeWeightings[gradeTypeId] ?? Weight.zero
            : null,
        WeightType.perGradeType => termSub.gradeTypeWeights.isNotEmpty
            ? termSub.gradeTypeWeights[gradeTypeId] ?? Weight.zero
            : null,
        WeightType.perGrade => throw UnimplementedError(),
      };
    }

    var takeIntoAccountState = TakeIntoAccountState.enabled;
    if (getWeightFor(_gradeType.id) == Weight.zero) {
      takeIntoAccountState = TakeIntoAccountState.disabledGradeTypeWithNoWeight;
    }
    if (_gradingSystemOfSelectedTerm != null &&
        _gradingSystem != _gradingSystemOfSelectedTerm) {
      takeIntoAccountState = TakeIntoAccountState.disabledWrongGradingSystem;
    }

    final posGradesRes = gradesService.getPossibleGrades(_gradingSystem);
    SelectableGrades selectableGrades = (
      distinctGrades: _getPossibleDistinctGrades(posGradesRes),
      nonDistinctGrades: posGradesRes is ContinuousNumericalPossibleGradesResult
          ? (
              min: posGradesRes.min,
              max: posGradesRes.max,
              decimalsAllowed: posGradesRes.decimalsAllowed
            )
          : null
    );

    return GradesDialogView(
      selectedGrade: _grade,
      selectableGrades: selectableGrades,
      selectedGradingSystem: _gradingSystem,
      selectedSubject:
          subject != null ? (id: subject.id, name: subject.name) : null,
      selectableSubjects: _subjects
          .map((s) => (
                id: s.id,
                name: s.name,
                abbreviation: s.abbreviation,
                design: s.design,
              ))
          .toIList(),
      selectedDate: _date,
      selectedGradingType: _gradeType,
      selectableGradingTypes: gradesService.getPossibleGradeTypes(),
      selectedTerm: _selectedTermId != null
          // The term name can be null if the term is selected and deleted from
          // a different device while the dialog is open.
          ? (id: _selectedTermId!, name: term?.name ?? '?')
          : null,
      selectableTerms:
          _selectableTerms.map((t) => (id: t.id, name: t.name)).toIList(),
      detailsController: _detailsController,
      title: _title,
      titleErrorText: _titleErrorText,
      takeIntoAccount: _takeIntoAccount,
      titleController: _titleController,
      isSubjectMissing: _isSubjectMissing,
      isGradeTypeMissing: _isGradeTypeMissing,
      isGradeMissing: _isGradeMissing,
      selectedGradeErrorText: _gradeErrorText,
      isTermMissing: _isTermMissing,
      takeIntoAccountState: takeIntoAccountState,
      gradeFieldController: _gradeFieldController,
    );
  }

  GradesDialogController({
    required this.gradesService,
    required this.coursesStream,
    required this.crashAnalytics,
    required this.analytics,
  }) {
    _selectedTermId = _getActiveTermId();
    _gradingSystemOfSelectedTerm = _getGradingSystemOfTerm(_selectedTermId);
    _gradingSystem =
        _gradingSystemOfSelectedTerm ?? GradingSystem.oneToSixWithPlusAndMinus;
    _date = Date.today();
    _gradeType = GradeType.writtenExam;
    _title = _gradeType.predefinedType?.toUiString();
    _takeIntoAccount = true;
    _titleController = TextEditingController(text: _title);
    _subjects = gradesService.getSubjects();
    _gradeFieldController = TextEditingController();
    _detailsController = TextEditingController();

    // Even though the fields are not filled at the beginning, we don't want to
    // show any error messages. The user should see the error messages only
    // after they have pressed the save button.
    _isGradeMissing = false;
    _isSubjectMissing = false;
    _isTermMissing = false;
    _isGradeTypeMissing = false;

    _listenToCourses();
    _listenToTerms();
  }

  void _listenToCourses() {
    _coursesStreamSubscription = coursesStream.listen((courses) {
      _subjects = _mergeCoursesAndSubjects(courses);
      _courses = courses.toIList();
      notifyListeners();
    });
  }

  void _listenToTerms() {
    _termsStreamSubscription = gradesService.terms.listen((terms) {
      _selectableTerms = terms;
      notifyListeners();
    });
  }

  TermId? _getActiveTermId() {
    final terms = gradesService.terms.value;
    return terms.firstWhereOrNull((term) => term.isActiveTerm)?.id;
  }

  GradingSystem? _getGradingSystemOfTerm(TermId? termId) {
    if (termId == null) {
      return null;
    }

    final term =
        gradesService.terms.value.firstWhere((term) => term.id == termId);
    return term.gradingSystem;
  }

  /// Merges the courses from the group system with the subject from the grades
  /// features.
  IList<Subject> _mergeCoursesAndSubjects(List<Course> courses) {
    final subjects = <Subject>[...gradesService.getSubjects()];
    for (final course in courses) {
      final matchingSubject = subjects
          .firstWhereOrNull((subject) => subject.name == course.subject);
      final hasSubjectForThisCourse = matchingSubject != null;
      if (!hasSubjectForThisCourse) {
        final subjectId = SubjectId(Id.generate().value);
        subjects.add(course.toSubject(subjectId));
      }
    }
    return IList(subjects);
  }

  String? _grade;
  late bool _isGradeMissing;
  String? _gradeErrorText;
  void setGrade(String res) {
    _grade = res.isEmpty ? null : res;
    _validateGrade();
  }

  bool _validateGrade() {
    final isEmpty = _grade == null || _grade!.isEmpty;
    if (isEmpty) {
      _gradeErrorText = 'Bitte eine Note eingeben.';
      _isGradeMissing = true;
      notifyListeners();
      return false;
    }

    final hasDistinctValues = view.selectableGrades.distinctGrades != null;
    if (hasDistinctValues) {
      _gradeErrorText = null;
      _isGradeMissing = false;
      notifyListeners();
      return true;
    }

    final isParsable = _isGradeParsable();
    _gradeErrorText = isParsable ? null : 'Die Eingabe ist keine gültige Zahl.';
    _isGradeMissing = false;
    notifyListeners();
    return isParsable;
  }

  bool _isGradeParsable() {
    try {
      final g = _grade!.replaceAll(',', '.');
      double.parse(g);
      return true;
    } catch (e) {
      return false;
    }
  }

  late GradingSystem _gradingSystem;
  void setGradingSystem(GradingSystem res) {
    final previousSystem = _gradingSystem;
    final hasSystemChanged = previousSystem != res;
    if (!hasSystemChanged) {
      return;
    }

    // We reset the grade value after changing the grade system because it's
    // likely that the grade and the grade system doesn't match anymore.
    _resetGradeField();
    _gradingSystem = res;
    notifyListeners();
  }

  late IList<Subject> _subjects;
  IList<Course> _courses = IList();
  late bool _isSubjectMissing;
  SubjectId? _selectSubjectId;
  void setSubject(SubjectId res) {
    _selectSubjectId = res;
    _isSubjectMissing = false;
    notifyListeners();
  }

  bool _isSubjectValid() {
    return _selectSubjectId != null;
  }

  bool _validateSubject() {
    final isValid = _isSubjectValid();
    _isSubjectMissing = !isValid;
    notifyListeners();
    return isValid;
  }

  late Date _date;
  void setDate(Date date) {
    _date = date;
    notifyListeners();
  }

  TermId? _selectedTermId;
  late bool _isTermMissing;
  GradingSystem? _gradingSystemOfSelectedTerm;
  IList<TermResult> _selectableTerms = IList(const []);
  void setTerm(TermId res) {
    _selectedTermId = res;
    _isTermMissing = false;

    final gradingSystemOfTerm = _getGradingSystemOfTerm(res);
    // In case the user hasn't entered a grade yet, we set the grading system of
    // the term as the default grading system.
    final hasGradeEntered = _grade != null && _grade!.isNotEmpty;
    if (!hasGradeEntered && gradingSystemOfTerm != null) {
      _gradingSystem = gradingSystemOfTerm;
    }

    _gradingSystemOfSelectedTerm = gradingSystemOfTerm;

    notifyListeners();
  }

  bool _isTermValid() {
    return _selectedTermId != null;
  }

  bool _validateTerm() {
    final isValid = _isTermValid();
    _isTermMissing = !isValid;
    notifyListeners();
    return isValid;
  }

  late bool _takeIntoAccount;
  void setIntegrateGradeIntoSubjectGrade(bool newVal) {
    _takeIntoAccount = newVal;
    notifyListeners();
  }

  late GradeType _gradeType;
  late bool _isGradeTypeMissing;
  late TextEditingController _gradeFieldController;
  void setGradeType(GradeType res) {
    final previousGradeType = _gradeType;
    _gradeType = res;
    _isGradeTypeMissing = false;
    _maybeSetTitleWithGradeType(res, previousGradeType);
    notifyListeners();
  }

  void _resetGradeField() {
    _grade = null;
    _gradeFieldController.clear();
  }

  void _maybeSetTitleWithGradeType(GradeType newType, GradeType? previousType) {
    final isTitleEmpty = _title == null || _title!.isEmpty;
    final isTitleAsPreviousType = previousType != null &&
        _title == previousType.predefinedType?.toUiString();

    if (isTitleEmpty || isTitleAsPreviousType) {
      final typeDisplayName = newType.predefinedType?.toUiString();
      _title = typeDisplayName;
      _titleController.text = typeDisplayName ?? '';
      _titleErrorText = null;
    }
  }

  String? _title;
  String? _titleErrorText;
  late TextEditingController _titleController;
  void setTitle(String res) {
    _title = res;
    _validateTitle();
  }

  bool _validateTitle() {
    final isValid = _isTitleValid();
    _titleErrorText = isValid ? null : 'Bitte einen Titel eingeben.';
    notifyListeners();
    return isValid;
  }

  bool _isTitleValid() {
    return _title != null && _title!.isNotEmpty;
  }

  late TextEditingController _detailsController;

  Future<void> save() async {
    final invalidFields = _validateFields();

    if (invalidFields.isNotEmpty) {
      _throwInvalidSaveState(invalidFields);
      return;
    }

    final isNewSubject = gradesService
        .getSubjects()
        .where((s) => s.id == _selectSubjectId)
        .isEmpty;
    if (isNewSubject) {
      _createSubject();

      // Firestore had a soft limit of 1 write per second per document. However,
      // this limit isn't mentioned in the documentation anymore. We still keep
      // the delay to be on the safe side.
      //
      // https://stackoverflow.com/questions/74454570/has-firestore-removed-the-soft-limit-of-1-write-per-second-to-a-single-document
      await Future.delayed(const Duration(seconds: 1));
    }

    _addGradeToGradeService();
    _logGradeAdded();
  }

  /// Validates the fields and returns the invalid ones.
  ///
  /// If all fields are valid, an empty list is returned.
  List<GradingDialogFields> _validateFields() {
    final invalidFields = <GradingDialogFields>[];

    if (!_validateGrade()) {
      invalidFields.add(GradingDialogFields.gradeValue);
    }

    if (!_validateSubject()) {
      invalidFields.add(GradingDialogFields.subject);
    }

    if (!_validateTerm()) {
      invalidFields.add(GradingDialogFields.term);
    }

    if (!_validateTitle()) {
      invalidFields.add(GradingDialogFields.title);
    }

    return invalidFields;
  }

  void _addGradeToGradeService() {
    String? details;
    if (_detailsController.text.isNotEmpty) {
      details = _detailsController.text;
    }

    final takeIntoAccount =
        switch ((_takeIntoAccount, view.takeIntoAccountState)) {
      // If the grade type has no weight, it will not be taken into account
      // anyways. Thus we can takeIntoAccount true here, so its easier for the
      // user when changing the weight of the grade type afterwards, so that he
      // doesn't have to manually enable "takeIntoAccount" it as well.
      (_, TakeIntoAccountState.disabledGradeTypeWithNoWeight) => true,
      // It will automatically not be taken into account if the grading system
      // of the term is different from the selected grading system. Thus we can
      // takeIntoAccount true here, so its easier for the user when changing the
      // grade type afterwards.
      (_, TakeIntoAccountState.disabledWrongGradingSystem) => true,
      (true, _) => true,
      (false, _) => false,
    };

    try {
      gradesService.term(_selectedTermId!).subject(_selectSubjectId!).addGrade(
            GradeInput(
              type: _gradeType.id,
              value: _grade!,
              date: _date,
              takeIntoAccount: takeIntoAccount,
              gradingSystem: _gradingSystem,
              title: _title!,
              details: details,
            ),
          );
    } catch (e, s) {
      if (e is InvalidGradeValueException) {
        _gradeErrorText = 'Die Note ist ungültig.';
        notifyListeners();
        throw const SingleInvalidFieldSaveGradeException(
            GradingDialogFields.gradeValue);
      }

      crashAnalytics.recordError('Error saving grade: $e', s);
      throw UnknownSaveGradeException(e);
    }
  }

  void _logGradeAdded() {
    analytics.log(NamedAnalyticsEvent(name: 'grade_added'));
  }

  void _createSubject() {
    final subject = _subjects.firstWhereOrNull((s) => s.id == _selectSubjectId);
    if (subject == null) {
      throw Exception('Selected subject id does not exists');
    }

    final connectedCourses = _getConnectedCourses(subject.id);

    gradesService.addSubject(
      // Not passing the id here would require some refactoring, so for now we
      // just pass the id of the subject.
      // ignore: invalid_use_of_visible_for_testing_member
      id: subject.id,
      SubjectInput(
        abbreviation: subject.abbreviation,
        design: subject.design,
        name: subject.name,
        connectedCourses: connectedCourses,
      ),
    );
  }

  IList<ConnectedCourse> _getConnectedCourses(SubjectId subjectId) {
    final subject = _subjects.firstWhere((s) => s.id == subjectId);
    return _courses
        .where((c) => c.subject == subject.name)
        .map(
          (c) => ConnectedCourse(
            id: CourseId(c.id),
            abbreviation: c.abbreviation,
            name: c.name,
            subjectName: c.subject,
          ),
        )
        .toIList();
  }

  void _throwInvalidSaveState(List<GradingDialogFields> invalidFields) {
    assert(invalidFields.isNotEmpty, 'Invalid fields must not be empty.');

    if (invalidFields.length > 1) {
      throw MultipleInvalidFieldsSaveGradeException(invalidFields);
    }

    final field = invalidFields.first;
    throw SingleInvalidFieldSaveGradeException(field);
  }

  IList<String>? _getPossibleDistinctGrades(PossibleGradesResult posGradesRes) {
    if (posGradesRes is NonNumericalPossibleGradesResult) {
      return posGradesRes.grades;
    }

    if (posGradesRes is ContinuousNumericalPossibleGradesResult) {
      if (!posGradesRes.decimalsAllowed) {
        final grades = <String>[];
        for (int i = posGradesRes.min.toInt();
            i <= posGradesRes.max.toInt();
            i++) {
          grades.add(i.toString());
        }
        return grades.toIList();
      }

      if (posGradesRes.specialGrades.isEmpty) {
        return null;
      }

      return posGradesRes.specialGrades.keys.toIList();
    }

    return null;
  }

  @override
  void dispose() {
    _coursesStreamSubscription.cancel();
    _termsStreamSubscription.cancel();
    super.dispose();
  }
}

extension on Course {
  Subject toSubject(SubjectId subjectId) {
    return Subject(
      id: subjectId,
      abbreviation: abbreviation,
      design: getDesign(),
      name: subject,
      connectedCourses: IList([
        ConnectedCourse(
          id: CourseId(id),
          name: name,
          abbreviation: abbreviation,
          subjectName: subject,
        )
      ]),
    );
  }
}

enum GradingDialogFields {
  gradeValue,
  subject,
  term,
  title;

  String toUiString() {
    return switch (this) {
      gradeValue => 'Note',
      title => 'Titel',
      subject => 'Fach',
      term => 'Halbjahr',
    };
  }
}

sealed class SaveGradeException implements Exception {
  const SaveGradeException();
}

class UnknownSaveGradeException extends SaveGradeException {
  final Object e;

  const UnknownSaveGradeException(this.e);
}

class MultipleInvalidFieldsSaveGradeException extends SaveGradeException {
  final List<GradingDialogFields> invalidFields;

  const MultipleInvalidFieldsSaveGradeException(this.invalidFields);
}

class SingleInvalidFieldSaveGradeException extends SaveGradeException {
  final GradingDialogFields invalidField;

  const SingleInvalidFieldSaveGradeException(this.invalidField);
}
