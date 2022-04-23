// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

extension HomeworkSortToEnumExtension on Sort<HomeworkReadModel> {
  HomeworkSort toEnum() {
    if (this is SmallestDateSubjectAndTitleSort) {
      return HomeworkSort.smallestDateSubjectAndTitle;
    } else if (this is SubjectSmallestDateAndTitleSort) {
      return HomeworkSort.subjectSmallestDateAndTitleSort;
    }
    throw UnimplementedError(
        'Sort<HomeworkReadModel>.toEnum not implemented for $runtimeType');
  }
}

extension HomeworkSortEnumToSortExtension on HomeworkSort {
  Sort<HomeworkReadModel> toSortObject({Date Function() getCurrentDate}) {
    switch (this) {
      case HomeworkSort.smallestDateSubjectAndTitle:
        return SmallestDateSubjectAndTitleSort(getCurrentDate: getCurrentDate);
      case HomeworkSort.subjectSmallestDateAndTitleSort:
        return SubjectSmallestDateAndTitleSort();
    }
    throw UnimplementedError();
  }
}
