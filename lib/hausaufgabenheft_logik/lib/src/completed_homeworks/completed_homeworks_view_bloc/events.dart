// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';

abstract class CompletedHomeworksViewBlocEvent extends Equatable {}

class StartTransformingHomeworks extends CompletedHomeworksViewBlocEvent {
  @override
  List<Object> get props => [];
}

class AdvanceCompletedHomeworks extends CompletedHomeworksViewBlocEvent {
  final int advanceBy;
  @override
  List<Object> get props => [advanceBy];
  AdvanceCompletedHomeworks(this.advanceBy);
}
