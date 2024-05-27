// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/models/homework_completion_status.dart';

import '../open_homeworks/sort_and_subcategorization/sort/src/sort.dart';
import 'date.dart';
import 'homework.dart';
import 'subject.dart';

extension SortWith<T> on List<T> {
  void sortWith(Sort<T> sort) {
    sort.sort(this);
  }
}

extension HomeworkListExtension on List<HomeworkReadModel> {
  List<HomeworkReadModel> get completed =>
      where((homework) => homework.status == CompletionStatus.completed)
          .toList();
  List<HomeworkReadModel> get open =>
      where((homework) => homework.status == CompletionStatus.open).toList();

  List<Subject> getDistinctOrderedSubjects() {
    final subjects = <Subject>{};
    for (final homework in this) {
      subjects.add(homework.subject);
    }
    return subjects.toList();
  }

  List<HomeworkReadModel> getOverdue([Date? now]) {
    now = now ?? Date.now();
    return where((homeworks) => homeworks.isOverdueRelativeTo(now!)).toList();
  }
}
