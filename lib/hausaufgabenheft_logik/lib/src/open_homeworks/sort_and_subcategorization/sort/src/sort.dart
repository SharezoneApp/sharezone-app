// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

import 'homework_attribute_sorts.dart';
import 'sort_with_operations.dart';

sealed class Sort<T> {
  IList<T> sort(IList<T> list);
}

/// Sorts the homeworks firstly by date (earliest date first).
/// If they have the same date, they will be sorted alphabetically by subject.
/// If they have the same date and subject, they will be sorted alphabetically by title.
class SmallestDateSubjectAndTitleSort extends Sort<HomeworkReadModel> {
  late Date Function() getCurrentDate;

  SmallestDateSubjectAndTitleSort({Date Function()? getCurrentDate}) {
    this.getCurrentDate = getCurrentDate ?? () => Date.now();
  }

  @override
  IList<HomeworkReadModel> sort(IList<HomeworkReadModel> list) {
    return sortWithOperations<HomeworkReadModel>(
        list, const IListConst([dateSort, subjectSort, titleSort]));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SmallestDateSubjectAndTitleSort &&
            other.getCurrentDate == getCurrentDate;
  }

  @override
  int get hashCode => getCurrentDate.hashCode;
}

/// Sorts the homeworks firstly by Subject.
/// If they have the same subject, they will be sorted by date (earliest date first).
/// If they have the same date and subject, they will be sorted alphabetically by title.
class SubjectSmallestDateAndTitleSort extends Sort<HomeworkReadModel> {
  @override
  IList<HomeworkReadModel> sort(IList<HomeworkReadModel> list) {
    return sortWithOperations<HomeworkReadModel>(
        list, const IListConst([subjectSort, dateSort, titleSort]));
  }

  @override
  bool operator ==(Object other) => true;

  @override
  int get hashCode => 1337;
}
