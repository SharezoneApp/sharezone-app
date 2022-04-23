// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';

abstract class LazyLoadingCompletedHomeworksEvent extends Equatable {}

class LoadCompletedHomeworks extends LazyLoadingCompletedHomeworksEvent {
  final int numberOfHomeworksToLoad;

  LoadCompletedHomeworks(this.numberOfHomeworksToLoad);

  @override
  List<Object> get props => [numberOfHomeworksToLoad];

  @override
  String toString() {
    return 'LoadCompletedHomeworks(numberOfHomeworksToLoad: $numberOfHomeworksToLoad)';
  }
}

class AdvanceCompletedHomeworks extends LazyLoadingCompletedHomeworksEvent {
  final int advanceBy;

  AdvanceCompletedHomeworks(this.advanceBy);

  @override
  List<Object> get props => [advanceBy];

  @override
  String toString() {
    return 'AdvanceCompletedHomeworks(advanceBy: $advanceBy)';
  }
}
