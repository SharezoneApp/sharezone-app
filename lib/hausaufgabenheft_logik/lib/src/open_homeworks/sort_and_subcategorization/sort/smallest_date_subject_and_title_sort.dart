// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import '../../../models/homework/homework.dart';
import '../../../models/date.dart';
import 'src/sort.dart';
import 'src/sort_with_operations.dart';
import 'src/homework_attribute_sorts.dart';

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is SmallestDateSubjectAndTitleSort &&
            other.getCurrentDate == getCurrentDate;
  }

  @override
  int get hashCode => getCurrentDate.hashCode;
}
