// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

import 'homework_tile.dart';

void dispatchCompletionStatusChange(
    HomeworkStatus newStatus, String homeworkId, HomeworkPageBloc bloc) {
  final bool newValue = newStatus == HomeworkStatus.completed;
  bloc.add(CompletionStatusChanged(homeworkId, newValue));
}
