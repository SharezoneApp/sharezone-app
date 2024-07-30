// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/src/models/homework_completion_status.dart';

import 'open_homeworks/sort_and_subcategorization/sort/src/student_sort.dart';
import 'models/date.dart';
import 'models/homework.dart';
import 'models/subject.dart';

extension SortWith<T> on IList<T> {
  IList<T> sortWith(Sort<T> sort) {
    return sort.sort(this);
  }
}

extension HomeworkListExtension on IList<StudentHomeworkReadModel> {
  IList<StudentHomeworkReadModel> get completed =>
      where((homework) => homework.status == CompletionStatus.completed)
          .toIList();
  IList<StudentHomeworkReadModel> get open =>
      where((homework) => homework.status == CompletionStatus.open).toIList();

  IList<Subject> getDistinctOrderedSubjects() {
    final subjects = <Subject>{};
    for (final homework in this) {
      subjects.add(homework.subject);
    }
    return subjects.toIList();
  }

  IList<StudentHomeworkReadModel> getOverdue([Date? now]) {
    now = now ?? Date.now();
    return where((homeworks) => homeworks.isOverdueRelativeTo(now!)).toIList();
  }
}
