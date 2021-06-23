import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';

import 'homework_tile.dart';

void dispatchCompletionStatusChange(
    HomeworkStatus newStatus, String homeworkId, HomeworkPageBloc bloc) {
  final bool newValue = newStatus == HomeworkStatus.completed;
  bloc.add(CompletionStatusChanged(homeworkId, newValue));
}
