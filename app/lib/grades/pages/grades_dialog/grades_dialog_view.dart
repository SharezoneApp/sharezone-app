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
import 'package:flutter/material.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

typedef SelectableGrades = ({
  IList<String>? distinctGrades,
  NonDistinctGrades? nonDistinctGrades
});
typedef NonDistinctGrades = ({num min, num max, bool decimalsAllowed});

class GradesDialogView {
  final String? selectedGrade;
  final TextEditingController gradeFieldController;

  /// Used to display an error message if the entered grade is invalid.
  ///
  /// Is only used for grading systems where a text field is displayed.
  ///
  /// If `null` no error message is displayed.
  final String? selectedGradeErrorText;

  /// If `true`, the action text to select a grade will change to red.
  ///
  /// This is used to indicate that the user must select a grade when the user
  /// clicks the save button.
  ///
  /// This is only used for grading systems where the user must select a grade
  /// from a list.
  final bool isGradeMissing;

  final SelectableGrades selectableGrades;

  /// The selected grading system.
  ///
  /// Defaults to "1 - 6 (+-)".
  final GradingSystem selectedGradingSystem;

  /// The selected subject.
  final ({SubjectId id, String name})? selectedSubject;

  /// If `true`, the action text to select a subject will change to red.
  ///
  /// This is used to indicate that the user must select a subject when the user
  /// clicks the save button.
  final bool isSubjectMissing;
  final IList<SubjectView> selectableSubjects;

  /// The selected date in the format "Sat, Mar 16, 2024".
  ///
  /// Defaults to the current date.
  final Date selectedDate;

  final GradeType selectedGradingType;

  /// If `true`, the action text to select a grade type will change to red.
  ///
  /// This is used to indicate that the user must select a grade type when the
  /// user clicks the save button.
  final bool isGradeTypeMissing;
  final IList<GradeType> selectableGradingTypes;

  final bool takeIntoAccount;
  final bool isTakeIntoAccountEnabled;
  final ({TermId id, String name})? selectedTerm;

  /// If `true`, the action text to select a term will change to red.
  ///
  /// This is used to indicate that the user must select a term when the user
  /// clicks the save button.
  final bool isTermMissing;
  final IList<({TermId id, String name})> selectableTerms;
  final String? title;
  final String? titleErrorText;
  final TextEditingController titleController;
  final String? details;

  const GradesDialogView({
    required this.selectedGrade,
    required this.selectableGrades,
    required this.selectedGradingSystem,
    required this.selectedSubject,
    required this.selectableSubjects,
    required this.selectedDate,
    required this.selectedGradingType,
    required this.selectableGradingTypes,
    required this.selectedTerm,
    required this.selectableTerms,
    required this.title,
    required this.titleErrorText,
    required this.details,
    required this.takeIntoAccount,
    required this.isTakeIntoAccountEnabled,
    required this.titleController,
    required this.isSubjectMissing,
    required this.isGradeTypeMissing,
    required this.isGradeMissing,
    required this.selectedGradeErrorText,
    required this.isTermMissing,
    required this.gradeFieldController,
  });
}

typedef SubjectView = ({
  String abbreviation,
  Design design,
  SubjectId id,
  String name
});

extension GradeSystemToName on GradingSystem {
  String get displayName {
    return switch (this) {
      GradingSystem.oneToSixWithPlusAndMinus => '1 - 6 (+-)',
      GradingSystem.oneToSixWithDecimals => '1 - 6 (mit Kommazahlen)',
      GradingSystem.sixToOneWithDecimals => '6 - 1 (mit Kommazahlen)',
      GradingSystem.oneToFiveWithDecimals => '1 - 5 (mit Kommazahlen)',
      GradingSystem.zeroToFivteenPoints => '15 - 0 Punkte',
      GradingSystem.zeroToFivteenPointsWithDecimals =>
        '15 - 0 Punkte (mit Kommazahlen)',
      GradingSystem.zeroToHundredPercentWithDecimals =>
        '100% - 0% (mit Kommazahlen)',
      GradingSystem.austrianBehaviouralGrades =>
        'Österreichische Verhaltensnoten',
    };
  }
}
