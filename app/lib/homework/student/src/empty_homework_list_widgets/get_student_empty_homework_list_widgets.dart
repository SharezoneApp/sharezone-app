import 'package:flutter/material.dart';
import '../../student_homework_page.dart';
import 'homework_status.dart';
import 'student_empty_homework_list_widgets.dart';

Widget getStudentEmptyHomeworkListWidgetswithStatus(
    {HomeworkTab forTab, HomeworkPageStatus homeworkStatus}) {
  ArgumentError.checkNotNull(forTab);
  ArgumentError.checkNotNull(homeworkStatus);

  if (forTab == HomeworkTab.open && homeworkStatus.hasOpenHomeworks ||
      forTab == HomeworkTab.completed && homeworkStatus.hasCompletedHomeworks) {
    throw ArgumentError(
        "Requested placeholder for $forTab while there are still homeworks. This should not happen as the homeworks should be displayed rather than a placeholder");
  }

  if (homeworkStatus.hasOpenHomeworks) {
    // If the student has open homeworks the placeholder could only have been
    // requested for the completed homework tab.
    // So we know we are on StudentHomeworkTab.completed and there are open
    // homeworks
    assert(forTab == HomeworkTab.completed);
    return FireMotivation();
  } else {
    // This means either:
    // - open homeworks tab with no open homeworks
    assert(forTab == HomeworkTab.open && !homeworkStatus.hasOpenHomeworks ||
        // - completed homeworks tab with no open and completed homeworks
        forTab == HomeworkTab.completed &&
            !homeworkStatus.hasOpenHomeworks &&
            !homeworkStatus.hasCompletedHomeworks);
    return GameController();
  }
}
