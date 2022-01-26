// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';

import 'teacher_archived_homework_list_view.dart';
import 'teacher_open_homework_list_view.dart';

abstract class TeacherHomeworkPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class Success extends TeacherHomeworkPageState {
  final TeacherArchivedHomeworkListView archived;
  final TeacherOpenHomeworkListView open;

  Success(this.open, this.archived);

  @override
  List<Object> get props => [archived, open];

  @override
  String toString() {
    return 'Success(completed: $archived, open: $open)';
  }
}

/// Bloc has not yet been told to load the homeworks.
class Uninitialized extends TeacherHomeworkPageState {
  @override
  String toString() {
    return 'HomeworkPageStateUninitialized';
  }
}
