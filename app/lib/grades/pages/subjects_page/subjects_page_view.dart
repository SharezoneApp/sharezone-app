// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

class SubjectsPageView extends Equatable {
  final IList<SubjectListItemView> gradeSubjects;
  final IList<SubjectListItemView> coursesWithoutSubject;

  const SubjectsPageView({
    required this.gradeSubjects,
    required this.coursesWithoutSubject,
  });

  bool get hasGradeSubjects => gradeSubjects.isNotEmpty;
  bool get hasCoursesWithoutSubject => coursesWithoutSubject.isNotEmpty;

  @override
  List<Object?> get props => [gradeSubjects, coursesWithoutSubject];
}

class SubjectListItemView extends Equatable {
  final SubjectId id;
  final String name;
  final String abbreviation;
  final Design design;
  final IList<ConnectedCourse> connectedCourses;
  final bool canDelete;
  final IList<SubjectGradeView> grades;

  const SubjectListItemView({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.design,
    required this.connectedCourses,
    required this.canDelete,
    required this.grades,
  });

  bool get hasGrades => grades.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    name,
    abbreviation,
    design,
    connectedCourses,
    canDelete,
    grades,
  ];
}

class SubjectGradeView extends Equatable {
  final GradeId id;
  final String title;
  final String displayValue;
  final String termName;
  final Date date;
  final String gradeTypeName;

  const SubjectGradeView({
    required this.id,
    required this.title,
    required this.displayValue,
    required this.termName,
    required this.date,
    required this.gradeTypeName,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    displayValue,
    termName,
    date,
    gradeTypeName,
  ];
}
