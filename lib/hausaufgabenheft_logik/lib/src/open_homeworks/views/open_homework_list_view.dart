// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart' show DeepCollectionEquality;
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:meta/meta.dart';

import 'homework_section_view.dart';

class OpenHomeworkListView {
  final bool showCompleteOverdueHomeworkPrompt;
  final List<HomeworkSectionView> sections;
  final HomeworkSort sorting;

  OpenHomeworkListView(
    this.sections, {
    @required this.showCompleteOverdueHomeworkPrompt,
    @required this.sorting,
  }) : super();

  @override
  int get hashCode =>
      sections.hashCode & showCompleteOverdueHomeworkPrompt.hashCode;

  int get numberOfHomeworks {
    final listLengths = sections.map((s) => s.homeworks.length).toList();
    if (listLengths.isEmpty) {
      return 0;
    }
    return listLengths.reduce((i, i2) => i + i2);
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is OpenHomeworkListView &&
            showCompleteOverdueHomeworkPrompt ==
                other.showCompleteOverdueHomeworkPrompt &&
            DeepCollectionEquality().equals(sections, other.sections);
  }

  @override
  String toString() =>
      'OpenHomeworkListView(sections: $sections, showCompleteOverdueHomeworkPrompt: $showCompleteOverdueHomeworkPrompt)';
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
