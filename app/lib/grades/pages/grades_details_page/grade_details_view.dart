// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

class GradeDetailsView extends Equatable {
  final String gradeValue;
  final GradingSystem gradingSystem;
  final String subjectDisplayName;
  final String date;
  final PredefinedGradeTypes gradeType;
  final String termDisplayName;
  final bool? integrateGradeIntoSubjectGrade;
  final String? title;
  final String? details;

  const GradeDetailsView({
    required this.gradeValue,
    required this.gradingSystem,
    required this.subjectDisplayName,
    required this.date,
    required this.gradeType,
    required this.termDisplayName,
    this.integrateGradeIntoSubjectGrade,
    this.title,
    this.details,
  });

  @override
  List<Object?> get props => [
    gradeValue,
    gradingSystem,
    subjectDisplayName,
    date,
    gradeType,
    termDisplayName,
    integrateGradeIntoSubjectGrade,
    title,
    details,
  ];
}
