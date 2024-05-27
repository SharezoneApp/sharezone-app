// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

abstract class OpenHomeworkListBlocState {}

class Uninitialized extends OpenHomeworkListBlocState {}

class Success extends OpenHomeworkListBlocState {
  final List<HomeworkReadModel> homeworks;

  Success(this.homeworks);
}
