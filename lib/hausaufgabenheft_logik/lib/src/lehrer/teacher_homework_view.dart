import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/src/views/color.dart';
import 'package:meta/meta.dart';

class TeacherHomeworkView {
  final HomeworkId id;
  final String abbreviation;
  final bool colorDate;

  /// For homeworks where [withSubmissions] is false this means the number of
  /// students who marked the homework as completed.
  /// For homeworks where [withSubmissions] is true this means the number of
  /// submissions being submitted.
  final int nrOfStudentsCompletedOrSubmitted;
  final String subject;
  final String todoDate;
  final String title;
  final bool withSubmissions;
  final Color subjectColor;

  /// For homeworks where [withSubmissions] is false this means if the teacher
  /// is allowed to see the list of students who have (not) completed this
  /// homework (so  checked it off in their homework page).
  ///
  /// For homeworks where [withSubmissions] is true this means if the teacher is
  /// allowed to see the list of submissions of the students.
  final bool canViewCompletionOrSubmissionList;

  /// If the user has the permission to delete the homework for everyone in the
  /// group.
  final bool canDeleteForEveryone;

  /// If the user has the permission to edit the homework for everyone in the
  /// group.
  final bool canEditForEveryone;

  TeacherHomeworkView({
    @required this.id,
    @required this.abbreviation,
    @required this.colorDate,
    @required this.nrOfStudentsCompletedOrSubmitted,
    @required this.subject,
    @required this.todoDate,
    @required this.title,
    @required this.withSubmissions,
    @required this.subjectColor,
    @required this.canViewCompletionOrSubmissionList,
    @required this.canDeleteForEveryone,
    @required this.canEditForEveryone,
  });

  @override
  String toString() {
    return 'TeacherHomeworkView(id: $id, abbreviation: $abbreviation, colorDate: $colorDate, nrOfStudentsCompleted: $nrOfStudentsCompletedOrSubmitted, subject: $subject, todoDate: $todoDate, title: $title, withSubmissions: $withSubmissions, subjectColor: $subjectColor)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TeacherHomeworkView &&
        other.id == id &&
        other.abbreviation == abbreviation &&
        other.colorDate == colorDate &&
        other.nrOfStudentsCompletedOrSubmitted ==
            nrOfStudentsCompletedOrSubmitted &&
        other.subject == subject &&
        other.todoDate == todoDate &&
        other.title == title &&
        other.withSubmissions == withSubmissions &&
        other.subjectColor == subjectColor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        abbreviation.hashCode ^
        colorDate.hashCode ^
        nrOfStudentsCompletedOrSubmitted.hashCode ^
        subject.hashCode ^
        todoDate.hashCode ^
        title.hashCode ^
        withSubmissions.hashCode ^
        subjectColor.hashCode;
  }
}
