// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

sealed class Sort<F extends BaseHomeworkReadModel> {
  IList<T> sort<T extends BaseHomeworkReadModel>(IList<T> list);
}

extension SortWith<
  T extends BaseHomeworkReadModel,
  S extends BaseHomeworkReadModel
>
    on IList<T> {
  IList<T> sortWith(Sort<S> sort) {
    return sort.sort<T>(this);
  }
}

/// Sorts the homeworks firstly by date (earliest date first).
/// If they have the same date, they will be sorted alphabetically by subject.
/// If they have the same date and subject, they will be sorted alphabetically by title.
class SmallestDateSubjectAndTitleSort extends Sort<BaseHomeworkReadModel> {
  late Date Function() getCurrentDate;

  SmallestDateSubjectAndTitleSort({Date Function()? getCurrentDate}) {
    this.getCurrentDate = getCurrentDate ?? () => Date.now();
  }

  @override
  IList<T> sort<T extends BaseHomeworkReadModel>(IList<T> list) {
    return sortWithOperations<T>(
      list,
      IListConst<ComparisonResult Function(T, T)>(
        // ignore: prefer_const_literals_to_create_immutables
        [dateSort, subjectSort, titleSort],
      ),
    );
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
class SubjectSmallestDateAndTitleSort extends Sort<BaseHomeworkReadModel> {
  @override
  IList<T> sort<T extends BaseHomeworkReadModel>(IList<T> list) {
    return sortWithOperations<T>(
      list,
      IListConst<ComparisonResult Function(T, T)>(
        // ignore: prefer_const_literals_to_create_immutables
        [subjectSort, dateSort, titleSort],
      ),
    );
  }

  @override
  bool operator ==(Object other) => true;

  @override
  int get hashCode => 1337;
}

/// Sorts the homeworks firstly by weekday (Monday to Sunday).
/// If they have the same weekday, they will be sorted by date (earliest date
/// first). If they have the same weekday and date, they will be sorted
/// alphabetically by subject and finally by title.
class WeekdayDateSubjectAndTitleSort extends Sort<BaseHomeworkReadModel> {
  @override
  IList<T> sort<T extends BaseHomeworkReadModel>(IList<T> list) {
    return sortWithOperations<T>(
      list,
      IListConst<ComparisonResult Function(T, T)>([
        weekdaySort,
        dateSort,
        subjectSort,
        titleSort,
      ]),
    );
  }

  @override
  bool operator ==(Object other) => true;

  @override
  int get hashCode => 42;
}
