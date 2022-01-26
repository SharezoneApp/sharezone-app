// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart' show DeepCollectionEquality;
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'teacher_homework_section_view.dart';

class TeacherOpenHomeworkListView {
  final List<TeacherHomeworkSectionView> sections;
  final HomeworkSort sorting;

  TeacherOpenHomeworkListView(
    this.sections, {
    @required this.sorting,
  }) : super();

  int get numberOfHomeworks {
    final listLengths = sections.map((s) => s.homeworks.length).toList();
    if (listLengths.isEmpty) {
      return 0;
    }
    return listLengths.reduce((i, i2) => i + i2);
  }

  @override
  String toString() =>
      'OpenHomeworkListView(sorting: $sorting, sections: $sections)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is TeacherOpenHomeworkListView &&
        listEquals(other.sections, sections) &&
        other.sorting == sorting;
  }

  @override
  int get hashCode => sections.hashCode ^ sorting.hashCode;
}

enum HomeworkSort {
  /// Sorts the homeworks firstly by date (earliest date first).
  /// If they have the same date, they will be sorted alphabetically by subject.
  /// If they have the same date and subject, they will be sorted alphabetically by title.
  smallestDateSubjectAndTitle,

  /// Sorts the homeworks firstly by Subject.
  /// If they have the same subject, they will be sorted by date (earliest date first).
  /// If they have the same date and subject, they will be sorted alphabetically by title.
  subjectSmallestDateAndTitleSort,
}

const String _subjectSmallestDateAndTitleSortAsString =
    'smallestDateSubjectAndTitle';
const String _subjectSmallestDateAndTitleSort =
    'subjectSmallestDateAndTitleSort';

HomeworkSort homeworkSortFromString(String s) {
  switch (s) {
    case _subjectSmallestDateAndTitleSortAsString:
      return HomeworkSort.smallestDateSubjectAndTitle;
    case _subjectSmallestDateAndTitleSort:
      return HomeworkSort.subjectSmallestDateAndTitleSort;
  }
  throw UnimplementedError();
}

String homeworkSortToString(HomeworkSort s) {
  switch (s) {
    case HomeworkSort.smallestDateSubjectAndTitle:
      return _subjectSmallestDateAndTitleSortAsString;
    case HomeworkSort.subjectSmallestDateAndTitleSort:
      return _subjectSmallestDateAndTitleSort;
  }
  throw UnimplementedError();
}
