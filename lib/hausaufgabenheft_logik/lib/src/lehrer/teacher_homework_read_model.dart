import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/homework.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/models_used_by_homework.dart';
import 'package:meta/meta.dart';

/// Ein ReadModel für die Lehrer-Hausaufgaben-Seite.
/// Siehe [HomeworkReadModel].
class TeacherHomeworkReadModel {
  final HomeworkId id;
  final DateTime todoDate;
  final Subject subject;
  final Title title;
  final bool withSubmissions;
  final int nrOfStudentsCompleted;
  final bool canViewCompletions;
  final bool canViewSubmissions;

  /// If the user has the permission to delete the homework for everyone in the
  /// group.
  final bool canDeleteForEveryone;

  /// If the user has the permission to edit the homework for everyone in the
  /// group.
  final bool canEditForEveryone;

  TeacherHomeworkReadModel({
    @required this.id,
    @required this.todoDate,
    @required this.subject,
    @required this.title,
    @required this.withSubmissions,
    @required this.nrOfStudentsCompleted,
    @required this.canViewCompletions,
    @required this.canViewSubmissions,
    @required this.canDeleteForEveryone,
    @required this.canEditForEveryone,
  });

  /// Die Methode ist aus [HomeworkReadModel] kopiert - zusammenführen?
  bool isOverdueRelativeTo(Date today) {
    return Date.fromDateTime(todoDate) < today;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TeacherHomeworkReadModel &&
        other.id == id &&
        other.todoDate == todoDate &&
        other.subject == subject &&
        other.title == title &&
        other.withSubmissions == withSubmissions &&
        other.nrOfStudentsCompleted == nrOfStudentsCompleted &&
        other.canViewCompletions == canViewCompletions &&
        other.canViewSubmissions == canViewSubmissions;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        todoDate.hashCode ^
        subject.hashCode ^
        title.hashCode ^
        withSubmissions.hashCode ^
        nrOfStudentsCompleted.hashCode ^
        canViewCompletions.hashCode ^
        canViewSubmissions.hashCode;
  }

  @override
  String toString() {
    return 'TeacherHomeworkReadModel(id: $id, todoDate: $todoDate, subject: $subject, title: $title, withSubmissions: $withSubmissions, nrOfStudentsCompleted: $nrOfStudentsCompleted, canViewCompletions: $canViewCompletions, canViewSubmissions: $canViewSubmissions)';
  }
}
