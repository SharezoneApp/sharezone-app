// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

abstract class StudentHomeworkPageState extends Equatable {
  @override
  List<Object> get props => [];
}

class Success extends StudentHomeworkPageState {
  final LazyLoadingHomeworkListView<StudentHomeworkView> completed;
  final StudentOpenHomeworkListView open;

  Success(this.completed, this.open);

  @override
  List<Object> get props => [completed, open];

  @override
  String toString() {
    return 'Success(completed: $completed, open: $open)';
  }
}

/// Bloc has not yet been told to load the homeworks.
class Uninitialized extends StudentHomeworkPageState {
  @override
  String toString() {
    return 'HomeworkPageStateUninitialized';
  }
}
