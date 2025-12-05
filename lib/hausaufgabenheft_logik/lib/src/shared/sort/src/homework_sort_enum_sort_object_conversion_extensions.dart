// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart'
    hide
        SmallestDateSubjectAndTitleSort,
        SubjectSmallestDateAndTitleSort,
        WeekdayDateSubjectAndTitleSort,
        Sort;
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';

extension HomeworkSortToEnumExtension on Sort<BaseHomeworkReadModel> {
  HomeworkSort toEnum() {
    if (this is SmallestDateSubjectAndTitleSort) {
      return HomeworkSort.smallestDateSubjectAndTitle;
    } else if (this is SubjectSmallestDateAndTitleSort) {
      return HomeworkSort.subjectSmallestDateAndTitleSort;
    } else if (this is WeekdayDateSubjectAndTitleSort) {
      return HomeworkSort.weekdayDateSubjectAndTitle;
    }
    throw UnimplementedError(
      'Sort<HomeworkReadModel>.toEnum not implemented for $runtimeType',
    );
  }
}

extension StudentHomeworkSortEnumToSortExtension on HomeworkSort {
  Sort<BaseHomeworkReadModel> toSortObject({
    required Date Function()? getCurrentDate,
  }) {
    switch (this) {
      case HomeworkSort.smallestDateSubjectAndTitle:
        return SmallestDateSubjectAndTitleSort(getCurrentDate: getCurrentDate);
      case HomeworkSort.subjectSmallestDateAndTitleSort:
        return SubjectSmallestDateAndTitleSort();
      case HomeworkSort.weekdayDateSubjectAndTitle:
        return WeekdayDateSubjectAndTitleSort();
    }
  }
}
