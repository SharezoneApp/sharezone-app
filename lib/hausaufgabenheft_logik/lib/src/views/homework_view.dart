import 'package:hausaufgabenheft_logik/src/views/color.dart';
import 'package:meta/meta.dart';

class StudentHomeworkView {
  final String id;
  final String abbreviation;
  final bool colorDate;

  /// Whether the student has marked the homework as completed.
  /// This can either mean that he checked the checkbox on the homework page,
  /// submitted his submission or marked a submittable homework explicitly as
  /// "completed" even though he did not submit a submission.
  final bool isCompleted;
  final String subject;
  final String todoDate;
  final String title;
  final bool withSubmissions;
  final Color subjectColor;

  StudentHomeworkView({
    @required this.id,
    @required this.abbreviation,
    @required this.isCompleted,
    @required this.title,
    @required this.subject,
    @required this.todoDate,
    @required this.colorDate,
    @required this.withSubmissions,
    @required this.subjectColor,
  });

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is StudentHomeworkView &&
            other.id == id &&
            other.abbreviation == abbreviation &&
            other.isCompleted == isCompleted &&
            other.title == title &&
            other.subject == subject &&
            other.todoDate == todoDate &&
            other.withSubmissions == withSubmissions &&
            other.colorDate == colorDate &&
            other.subjectColor == subjectColor;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      abbreviation.hashCode ^
      isCompleted.hashCode ^
      title.hashCode ^
      subject.hashCode ^
      todoDate.hashCode ^
      colorDate.hashCode ^
      withSubmissions.hashCode ^
      subjectColor.hashCode;

  @override
  String toString() {
    return 'HomeworkView(id: $id, subject: $subject, abbreviation: $abbreviation, todoDate: $todoDate, colorDate: $colorDate, subjectColor: $subjectColor, done: $isCompleted, title: $title, withSubmissions: $withSubmissions)';
  }
}
