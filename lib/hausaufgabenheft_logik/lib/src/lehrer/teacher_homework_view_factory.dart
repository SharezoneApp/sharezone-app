import 'package:hausaufgabenheft_logik/src/models/homework/models_used_by_homework.dart';
import 'package:hausaufgabenheft_logik/src/views/color.dart';
import 'package:meta/meta.dart';

import '../../hausaufgabenheft_logik_lehrer.dart';
import 'teacher_homework_view.dart';

class TeacherHomeworkViewFactory {
  Date Function() _getCurrentDate;

  /// The color value from `color.value`.
  /// E.g. "0xFF03A9F4" for light blue.
  final int defaultColorValue;
  final Color defaultColor;

  TeacherHomeworkViewFactory(
      {Date Function() getCurrentDate, @required this.defaultColorValue})
      : defaultColor = Color(defaultColorValue) {
    if (getCurrentDate == null) {
      _getCurrentDate = () => Date.now();
    } else {
      _getCurrentDate = getCurrentDate;
    }
  }

  TeacherHomeworkView createFrom(TeacherHomeworkReadModel homework) {
    final twoDaysInFuture = _getCurrentDate().addDays(2);
    return TeacherHomeworkView(
      id: homework.id,
      title: homework.title.value,
      subject: homework.subject.name,
      abbreviation: homework.subject.abbreviation,
      todoDate: _getLocaleDateString(Date.fromDateTime(homework.todoDate),
          time: _getTime(homework.withSubmissions, homework.todoDate)),
      withSubmissions: homework.withSubmissions,
      nrOfStudentsCompletedOrSubmitted: homework.nrOfStudentsCompleted,
      canViewCompletionOrSubmissionList: homework.withSubmissions
          ? homework.canViewSubmissions
          : homework.canViewCompletions,
      colorDate: homework.isOverdueRelativeTo(twoDaysInFuture),
      subjectColor: homework.subject.color.orElse(defaultColor),
      canDeleteForEveryone: false,
      canEditForEveryone: false,
    );
  }

  String _getLocaleDateString(Date date, {String time}) {
    final months = {
      1: 'Januar',
      2: 'Februar',
      3: 'März',
      4: 'April',
      5: 'Mai',
      6: 'Juni',
      7: 'Juli',
      8: 'August',
      9: 'September',
      10: 'Oktober',
      11: 'November',
      12: 'Dezember',
    };
    assert(months.containsKey(date.month));

    final day = date.day.toString();
    final month = months[date.month];
    final year = date.year.toString();

    final dateString = '$day. $month $year';
    if (time == null) return dateString;
    return '$dateString - $time Uhr';
  }

  String _getTime(bool withSubmissions, DateTime dateTime) {
    if (!withSubmissions) return null;
    return '${dateTime.hour}:${_getMinute(dateTime.minute)}';
  }

  String _getMinute(int minute) {
    if (minute >= 10) return minute.toString();
    return '0$minute';
  }
}
