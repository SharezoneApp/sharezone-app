// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone_utils/random_string.dart';

import 'grades_dialog_view.dart';

class GradesDialogController extends ChangeNotifier {
  GradesDialogView get view {
    final subject =
        _subject != null ? gradesService.getSubject(_subject!) : null;
    final terms = gradesService.terms.value;
    final term = _term != null ? terms.firstWhere((t) => t.id == _term) : null;
    return GradesDialogView(
      selectedGrade: _grade,
      selectableGrades: gradesService.getPossibleGrades(_gradingSystem),
      selectedGradingSystem: _gradingSystem,
      selectedSubject:
          subject != null ? (id: subject.id, name: subject.name) : null,
      selectableSubjects: gradesService
          .getSubjects()
          .map((e) => (id: e.id, name: e.name))
          .toIList(),
      selectedDate: _date,
      selectedGradingType: _gradeType,
      selectableGradingTypes: gradesService.getPossibleGradeTypes(),
      selectedTerm: _term != null ? (id: _term!, name: term!.name) : null,
      selectableTerms:
          terms.map((term) => (id: term.id, name: term.name)).toIList(),
      details: null,
      title: null,
      integrateGradeIntoSubjectGrade: _integrateGradeIntoSubjectGrade,
    );
  }

  final GradesService gradesService;

  GradesDialogController({required this.gradesService}) {
    _gradingSystem = GradingSystem.oneToSixWithPlusAndMinus;
    _date = Date.today();
    _gradeType = GradeType.writtenExam;
    _integrateGradeIntoSubjectGrade = true;

    // We add a subject so have at least one subject to select.
    // Currently selecting a course and it being transformed to a subject is not
    // implemented.
    try {
      gradesService.addSubject(
        Subject(
          id: const SubjectId('mathe'),
          name: 'Mathe',
          abbreviation: 'Ma',
          design: Design.random(),
        ),
      );
    } on SubjectAlreadyExistsException catch (_) {}
  }

  String? _grade;
  void setGrade(String res) {
    _grade = res;
    notifyListeners();
  }

  late GradingSystem _gradingSystem;
  void setGradingSystem(GradingSystem res) {
    _gradingSystem = res;
    notifyListeners();
  }

  SubjectId? _subject;
  void setSubject(SubjectId res) {
    _subject = res;
    notifyListeners();
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

  late GradeType _gradeType;
  void setGradeType(GradeType res) {
    _gradeType = res;
    notifyListeners();
  }

  void save() {
    final gradeId = GradeId(randomIDString(20));

    gradesService.addGrade(
      id: _subject!,
      termId: _term!,
      value: Grade(
        id: gradeId,
        type: _gradeType.id,
        value: _grade!,
        date: _date,
        takeIntoAccount: _integrateGradeIntoSubjectGrade,
        gradingSystem: _gradingSystem,
      ),
    );
  }
}
