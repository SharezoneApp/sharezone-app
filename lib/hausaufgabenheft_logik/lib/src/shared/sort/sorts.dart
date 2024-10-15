// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

export 'src/sort.dart';
export 'src/homework_attribute_sorts.dart';
export 'src/homework_sort_enum_sort_object_conversion_extensions.dart';
export 'src/sort_with_operations.dart';

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
}
