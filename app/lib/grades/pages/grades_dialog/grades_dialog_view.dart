// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

class GradesDialogView {
  /// The selected grading system.
  ///
  /// Defaults to "1 - 6 (+-)".
  final String selectedGradingSystem;

  /// The selected subject.
  final String? selectedSubject;

  /// The selected date in the format "Sat, Mar 16, 2024".
  ///
  /// Defaults to the current date.
  final String selectedDate;

  /// The selected grading type.
  ///
  /// Defaults to written exam.
  final String selectedGradingType;

  final bool integrateGradeIntoSubjectGrade;
  final String? selectedTerm;
  final String? title;
  final String? details;

  const GradesDialogView({
    required this.selectedGradingSystem,
    required this.selectedSubject,
    required this.selectedDate,
    required this.selectedGradingType,
    required this.selectedTerm,
    required this.title,
    required this.details,
    required this.integrateGradeIntoSubjectGrade,
  });
}
