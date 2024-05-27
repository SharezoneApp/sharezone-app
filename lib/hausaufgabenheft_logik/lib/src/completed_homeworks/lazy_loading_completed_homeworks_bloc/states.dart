// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

abstract class LazyLoadingCompletedHomeworksBlocState extends Equatable {}

class Success extends LazyLoadingCompletedHomeworksBlocState {
  final List<HomeworkReadModel> homeworks;
  final bool loadedAllHomeworks;

  Success(this.homeworks, {required this.loadedAllHomeworks});

  @override
  List<Object> get props => [homeworks, loadedAllHomeworks];
}

class Loading extends LazyLoadingCompletedHomeworksBlocState {
  @override
  List<Object> get props => [];
}
