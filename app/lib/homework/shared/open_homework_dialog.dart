// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/dashbord_widgets_blocs/holiday_bloc.dart';
import 'package:sharezone/blocs/homework/homework_dialog_bloc.dart';
import 'package:sharezone/pages/homework/homework_dialog.dart';
import 'package:sharezone/util/next_lesson_calculator/next_lesson_calculator.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<void> openHomeworkDialogAndShowConfirmationIfSuccessful(
  BuildContext context, {
  HomeworkDto? homework,
}) async {
  final api = BlocProvider.of<SharezoneContext>(context).api;
  final nextLessonCalculator = NextLessonCalculator(
    timetableGateway: api.timetable,
    userGateway: api.user,
    holidayManager: BlocProvider.of<HolidayBloc>(context).holidayManager,
  );

  final successful = await Navigator.push<bool>(
    context,
    IgnoreWillPopScopeWhenIosSwipeBackRoute(
      builder: (context) => HomeworkDialog(
        homeworkDialogApi: HomeworkDialogApi(api),
        nextLessonCalculator: nextLessonCalculator,
        homework: homework,
      ),
      settings: const RouteSettings(name: HomeworkDialog.tag),
    ),
  );
  if (successful == true && context.mounted) {
    await _showUserConfirmationOfHomeworkArrival(context: context);
  }
}

Future<void> _showUserConfirmationOfHomeworkArrival({
  required BuildContext context,
}) async {
  await waitingForPopAnimation();
  if (!context.mounted) return;
  showDataArrivalConfirmedSnackbar(context: context);
}
