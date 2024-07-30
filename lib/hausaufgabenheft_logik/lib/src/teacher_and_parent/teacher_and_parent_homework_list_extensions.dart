// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart' hide Sort;

extension HomeworkListExtension on IList<TeacherHomeworkReadModel> {
  IList<TeacherHomeworkReadModel> get completed =>
      where((homework) => homework.status == ArchivalStatus.archived).toIList();
  IList<TeacherHomeworkReadModel> get open =>
      where((homework) => homework.status == ArchivalStatus.open).toIList();

  IList<Subject> getDistinctOrderedSubjects() {
    final subjects = <Subject>{};
    for (final homework in this) {
      subjects.add(homework.subject);
    }
    return subjects.toIList();
  }

  IList<TeacherHomeworkReadModel> getOverdue([Date? now]) {
    now = now ?? Date.now();
    return where((homeworks) => homeworks.isOverdueRelativeTo(now!)).toIList();
  }
}
