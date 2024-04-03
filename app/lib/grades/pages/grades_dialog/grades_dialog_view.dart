// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/date.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

typedef SelectableGrades = ({IList<String>? distinctGrades, NonDistinctGrades? nonDistinctGrades});
typedef NonDistinctGrades = ({num min, num max, bool decimalsAllowed});


class GradesDialogView {
  final String? selectedGrade;
  final SelectableGrades selectableGrades;

  /// The selected grading system.
  ///
  /// Defaults to "1 - 6 (+-)".
  final GradingSystem selectedGradingSystem;

  /// The selected subject.
  final ({SubjectId id, String name})? selectedSubject;
  final IList<({SubjectId id, String name})> selectableSubjects;

  /// The selected date in the format "Sat, Mar 16, 2024".
  ///
  /// Defaults to the current date.
  final Date selectedDate;

  /// The selected grading type.
  ///
  /// Defaults to written exam.
  final GradeType selectedGradingType;
  final IList<GradeType> selectableGradingTypes;

  final bool integrateGradeIntoSubjectGrade;
  final ({TermId id, String name})? selectedTerm;
  final IList<({TermId id, String name})> selectableTerms;
  final String? title;
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
    required this.details,
    required this.integrateGradeIntoSubjectGrade,
  });
}

extension GradeSystemToName on GradingSystem {
  String get displayName {
    return switch (this) {
      GradingSystem.oneToSixWithPlusAndMinus => '1 - 6 (+-)',
      GradingSystem.zeroToFivteenPoints => '0 - 15 Punkte',
      GradingSystem.oneToSixWithDecimals => '1 - 6 (mit Kommazahlen)',
    };
  }
}
