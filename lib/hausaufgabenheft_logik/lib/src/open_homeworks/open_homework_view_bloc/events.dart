// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/homework.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort/src/sort.dart';

abstract class OpenHomeworkViewEvent extends Equatable {}

class LoadHomeworks extends OpenHomeworkViewEvent {
  final Sort<HomeworkReadModel> sort;

  LoadHomeworks(this.sort);

  @override
  List<Object> get props => [sort];

  @override
  String toString() {
    return 'LoadHomeworks(sort: $sort)';
  }
}

class SortingChanged extends OpenHomeworkViewEvent {
  final Sort<HomeworkReadModel> sort;

  SortingChanged(this.sort);

  @override
  List<Object> get props => [sort];

  @override
  String toString() {
    return 'SortingChanged(sort: $sort)';
  }
}
