// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/homework/parent/homework_page.dart';
import 'package:user/user.dart';
import 'student/student_homework_page.dart';
import 'teacher/teacher_homework_page.dart';

enum HomeworkPageTypeOfUser { student, parent, teacher }

HomeworkPageTypeOfUser typeOfUserToHomeworkPageTypeOfUserOrThrow(
    TypeOfUser? typeOfUser) {
  switch (typeOfUser) {
    case TypeOfUser.student:
      return HomeworkPageTypeOfUser.student;
    case TypeOfUser.teacher:
      return HomeworkPageTypeOfUser.teacher;
    case TypeOfUser.parent:
      return HomeworkPageTypeOfUser.parent;
    default:
      throw UnimplementedError();
  }
}

class NewHomeworkPage extends StatelessWidget {
  /// Can be converted from [TypeOfUser] via
  /// [typeOfUserToHomeworkPageTypeOfUserOrThrow].
  final HomeworkPageTypeOfUser currentUserType;
  const NewHomeworkPage({super.key, required this.currentUserType});

  @override
  Widget build(BuildContext context) {
    switch (currentUserType) {
      case HomeworkPageTypeOfUser.student:
        return const StudentHomeworkPage();
      case HomeworkPageTypeOfUser.parent:
        return const HomeworkPage();
      case HomeworkPageTypeOfUser.teacher:
        return const TeacherHomeworkPage();
      default:
        throw UnimplementedError();
    }
  }
}
