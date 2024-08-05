// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/src/shared/models/homework_completion_status.dart';

import '../shared/models/date.dart';
import '../shared/models/homework.dart';

extension StudentHomeworkListExtension on IList<StudentHomeworkReadModel> {
  IList<StudentHomeworkReadModel> get completed =>
      where((homework) => homework.status == CompletionStatus.completed)
          .toIList();
  IList<StudentHomeworkReadModel> get open =>
      where((homework) => homework.status == CompletionStatus.open).toIList();

  IList<StudentHomeworkReadModel> getOverdue([Date? now]) {
    now = now ?? Date.now();
    return where((homeworks) => homeworks.isOverdueRelativeTo(now!)).toIList();
  }
}
