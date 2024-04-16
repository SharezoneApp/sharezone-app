// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:date/date.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone_utils/random_string.dart';

import 'grades_dialog_view.dart';

class GradesDialogController extends ChangeNotifier {
  final Stream<List<Course>> coursesStream;
  late StreamSubscription<List<Course>> _coursesStreamSubscription;

  GradesDialogView get view {
    final subject = _selectSubjectId != null
        ? _subjects.singleWhere((s) => s.id == _selectSubjectId)
        : null;
    final terms = gradesService.terms.value;
    final term = _term != null ? terms.firstWhere((t) => t.id == _term) : null;

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
      selectedTerm: _term != null ? (id: _term!, name: term!.name) : null,
      selectableTerms:
          terms.map((term) => (id: term.id, name: term.name)).toIList(),
      details: null,
      title: _title,
      titleErrorText: _titleErrorText,
      integrateGradeIntoSubjectGrade: _integrateGradeIntoSubjectGrade,
      titleController: _titleController,
      isSubjectMissing: _isSubjectMissing,
      isGradeTypeMissing: _isGradeTypeMissing,
    );
  }

  final GradesService gradesService;

  GradesDialogController({
    required this.gradesService,
    required this.coursesStream,
  }) {
    _gradingSystem = GradingSystem.oneToSixWithPlusAndMinus;
    _date = Date.today();
    _gradeType = null;
    _integrateGradeIntoSubjectGrade = true;
    _titleController = TextEditingController();
    _subjects = gradesService.getSubjects();

    _coursesStreamSubscription = coursesStream.listen((courses) {
      _subjects = _mergeCoursesAndSubjects(courses);
      notifyListeners();
    });
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
        final subjectId = SubjectId(Id.generate().id);
        subjects.add(course.toSubject(subjectId));
      }
    }
    return IList(subjects);
  }

  String? _grade;
  void setGrade(String res) {
    _grade = res.isEmpty ? null : res;
    notifyListeners();
  }

  late GradingSystem _gradingSystem;
  void setGradingSystem(GradingSystem res) {
    _gradingSystem = res;
    notifyListeners();
  }

  late IList<Subject> _subjects;
  bool _isSubjectMissing = false;
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

  TermId? _term;
  void setTerm(TermId res) {
    _term = res;
    notifyListeners();
  }

  late bool _integrateGradeIntoSubjectGrade;
  void setIntegrateGradeIntoSubjectGrade(bool newVal) {
    _integrateGradeIntoSubjectGrade = newVal;
    notifyListeners();
  }

  GradeType? _gradeType;
  bool _isGradeTypeMissing = false;
  void setGradeType(GradeType res) {
    _gradeType = res;
    _isGradeTypeMissing = false;
    _maybeSetTitleWithGradeType(res);
    notifyListeners();
  }

  bool _isGradeTypeValid() {
    return _gradeType != null;
  }

  bool _validateGradeType() {
    final isValid = _isGradeTypeValid();
    _isGradeTypeMissing = !isValid;
    notifyListeners();
    return isValid;
  }

  void _maybeSetTitleWithGradeType(GradeType type) {
    if (_title == null || _title!.isEmpty) {
      final typeDisplayName = type.predefinedType?.toUiString();
      _title = typeDisplayName;
      _titleController.text = typeDisplayName ?? '';
    }
  }

  String? _title;
  String? _titleErrorText;
  late TextEditingController _titleController;
  void setTitle(String res) {
    _title = res;
    validateTitle();
  }

  bool validateTitle() {
    if (!_isTitleValid()) {
      _titleErrorText = 'Bitte einen Titel eingeben.';
      notifyListeners();
      return false;
    } else {
      _titleErrorText = null;
      notifyListeners();
      return true;
    }
  }

  bool _isTitleValid() {
    return _title != null && _title!.isNotEmpty;
  }

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
      createSubject();

      // Firestore had a soft limit of 1 write per second per document. However,
      // this limit isn't mentioned in the documentation anymore. We still keep
      // the delay to be on the safe side.
      //
      // https://stackoverflow.com/questions/74454570/has-firestore-removed-the-soft-limit-of-1-write-per-second-to-a-single-document
      await Future.delayed(const Duration(seconds: 1));
    }

    _addGradeToGradeService();
  }

  /// Validates the fields and returns the invalid ones.
  ///
  /// If all fields are valid, an empty list is returned.
  List<GradingDialogFields> _validateFields() {
    final invalidFields = <GradingDialogFields>[];

    if (!validateTitle()) {
      invalidFields.add(GradingDialogFields.title);
    }

    if (!_validateSubject()) {
      invalidFields.add(GradingDialogFields.subject);
    }

    if (!_validateGradeType()) {
      invalidFields.add(GradingDialogFields.gradeType);
    }

    return invalidFields;
  }

  void _addGradeToGradeService() {
    final gradeId = GradeId(randomIDString(20));
    gradesService.addGrade(
      id: _selectSubjectId!,
      termId: _term!,
      value: Grade(
        id: gradeId,
        type: _gradeType!.id,
        value: _grade!,
        date: _date,
        takeIntoAccount: _integrateGradeIntoSubjectGrade,
        gradingSystem: _gradingSystem,
        title: _title!,
      ),
    );
  }

  void createSubject() {
    final subject = _subjects.firstWhereOrNull((s) => s.id == _selectSubjectId);
    if (subject == null) {
      throw Exception('Selected subject id does not exists');
    }
    gradesService.addSubject(subject);
  }

  void _throwInvalidSaveState(List<GradingDialogFields> invalidFields) {
    assert(invalidFields.isNotEmpty, 'Invalid fields must not be empty.');

    if (invalidFields.length > 1) {
      throw MultipleInvalidFieldsSaveGradeException(invalidFields);
    }

    throw switch (invalidFields.first) {
      GradingDialogFields.title => const InvalidTitleSaveGradeException(),
      GradingDialogFields.subject => const SubjectMissingException(),
      GradingDialogFields.gradeType => const GradeTypeMissingException(),
    };
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
  subject,
  gradeType,
  title;

  String toUiString() {
    return switch (this) {
      title => 'Titel',
      subject => 'Fach',
      gradeType => 'Notentyp',
    };
  }
}

sealed class SaveGradeException implements Exception {
  const SaveGradeException();
}

class UnknownSaveGradeException extends SaveGradeException {
  const UnknownSaveGradeException();
}

class MultipleInvalidFieldsSaveGradeException extends SaveGradeException {
  final List<GradingDialogFields> invalidFields;

  const MultipleInvalidFieldsSaveGradeException(this.invalidFields);
}

class InvalidTitleSaveGradeException extends SaveGradeException {
  const InvalidTitleSaveGradeException();
}

class SubjectMissingException extends SaveGradeException {
  const SubjectMissingException();
}

class GradeTypeMissingException extends SaveGradeException {
  const GradeTypeMissingException();
}
