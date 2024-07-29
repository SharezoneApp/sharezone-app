// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart'
    hide HomeworkPageBloc;
import 'package:sharezone/homework/homework_dialog/homework_dialog.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'student/student_homework_page.dart';
import 'teacher_and_parent/teacher_and_parent_homework_page.dart';

enum SortBy { date, subject }

Map<SortBy, String> sortByAsString = {
  SortBy.date: "Datum",
  SortBy.subject: "Fach",
};

Future<void> openHomeworkDialogAndShowConfirmationIfSuccessful(
  BuildContext context, {
  HomeworkDto? homework,
}) async {
  final successful = await Navigator.push<bool>(
    context,
    IgnoreWillPopScopeWhenIosSwipeBackRoute(
      builder: (context) => HomeworkDialog(
        id: homework?.id != null ? HomeworkId(homework!.id) : null,
      ),
      settings: const RouteSettings(name: HomeworkDialog.tag),
    ),
  );
  if (successful == true && context.mounted) {
    await showUserConfirmationOfHomeworkArrival(context: context);
  }
}

Future<void> showUserConfirmationOfHomeworkArrival({
  required BuildContext context,
}) async {
  await waitingForPopAnimation();
  if (!context.mounted) return;
  showDataArrivalConfirmedSnackbar(context: context);
}

class HomeworkPage extends StatelessWidget {
  const HomeworkPage({super.key});
  static const String tag = 'homework-page';

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    // When hot-reloading this will cause the student homework page to be
    // displayed even if its the wrong type of user.
    final typeOfUser = api.user.data?.typeOfUser ?? TypeOfUser.student;

    switch (typeOfUser) {
      case TypeOfUser.student:
        return const StudentHomeworkPage();
      case TypeOfUser.teacher:
      case TypeOfUser.parent:
        return const TeacherAndParentHomeworkPage();
      case TypeOfUser.unknown:
        throw UnimplementedError();
    }
  }
}
