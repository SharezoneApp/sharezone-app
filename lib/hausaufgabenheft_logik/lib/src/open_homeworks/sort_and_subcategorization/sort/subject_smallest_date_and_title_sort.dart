// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import '../../../models/homework/homework.dart';
import 'src/sort.dart';
import 'src/sort_with_operations.dart';
import 'src/homework_attribute_sorts.dart';

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
  bool operator ==(dynamic other) => true;
}
