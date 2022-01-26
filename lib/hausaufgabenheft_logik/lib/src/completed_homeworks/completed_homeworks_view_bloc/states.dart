// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';

import 'package:hausaufgabenheft_logik/src/completed_homeworks/views/completed_homwork_list_view.dart';

abstract class CompletedHomeworksViewBlocState extends Equatable {}

class Loading extends CompletedHomeworksViewBlocState {
  @override
  List<Object> get props => [];
}

class Success extends CompletedHomeworksViewBlocState {
  final CompletedHomeworkListView completedHomeworksView;

  Success(this.completedHomeworksView);

  @override
  List<Object> get props => [completedHomeworksView];
}
