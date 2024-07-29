// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart'
    show HomeworkSort;

abstract class TeacherAndParentHomeworkPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Sorts all open homeworks with the given [sort].
class OpenHwSortingChanged extends TeacherAndParentHomeworkPageEvent {
  final HomeworkSort sort;

  OpenHwSortingChanged(this.sort);

  @override
  List<Object> get props => [sort];

  @override
  String toString() {
    return 'SortingChanged(sort: $sort)';
  }
}

/// Tells the bloc to start loading homeworks
class LoadHomeworks extends TeacherAndParentHomeworkPageEvent {
  @override
  String toString() {
    return 'LoadHomeworks';
  }
}

/// Advances the number of loaded, completed homeworks by [advanceBy].
/// For example:
/// Initial state: 5 completed Homeworks loaded.
/// Event dispatched: [AdvanceArchivedHomeworks] with [advanceBy] = 5
/// New state: 10 archived homeworks loaded.
///
/// If all homeworks are already loaded this won't do anything.
class AdvanceArchivedHomeworks extends TeacherAndParentHomeworkPageEvent {
  final int advanceBy;

  @override
  List<Object> get props => [advanceBy];

  AdvanceArchivedHomeworks(this.advanceBy);

  @override
  String toString() {
    return 'AdvanceCompletedHomeworks(advanceBy: $advanceBy)';
  }
}
