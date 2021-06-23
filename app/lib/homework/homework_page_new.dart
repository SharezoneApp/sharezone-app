import 'package:flutter/material.dart';
import 'package:sharezone/pages/homework_page.dart';
import 'package:user/user.dart';
import 'student/student_homework_page.dart';
import 'teacher/teacher_homework_page.dart';

enum HomeworkPageTypeOfUser { student, parent, teacher }

HomeworkPageTypeOfUser typeOfUserToHomeworkPageTypeOfUserOrThrow(
    TypeOfUser typeOfUser) {
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
  const NewHomeworkPage({Key key, @required this.currentUserType})
      : assert(currentUserType != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (currentUserType) {
      case HomeworkPageTypeOfUser.student:
        return StudentHomeworkPage();
      case HomeworkPageTypeOfUser.parent:
        return HomeworkPage();
      case HomeworkPageTypeOfUser.teacher:
        return TeacherHomeworkPage();
      default:
        throw UnimplementedError();
    }
  }
}
