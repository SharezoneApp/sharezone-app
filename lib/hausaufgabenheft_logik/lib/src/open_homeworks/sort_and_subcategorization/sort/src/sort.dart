// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

import 'homework_attribute_sorts.dart';
import 'sort_with_operations.dart';

sealed class Sort<T> {
  void sort(List<T> list);
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
  List<HomeworkReadModel> sort(List<HomeworkReadModel> list) {
    sortWithOperations<HomeworkReadModel>(
        list, List.from([dateSort, subjectSort, titleSort]));
    return list;
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
  List<HomeworkReadModel> sort(List<HomeworkReadModel> list) {
    sortWithOperations<HomeworkReadModel>(
        list, List.from([subjectSort, dateSort, titleSort]));
    return list;
  }

  @override
  bool operator ==(Object other) => true;

  @override
  int get hashCode => 1337;
}
