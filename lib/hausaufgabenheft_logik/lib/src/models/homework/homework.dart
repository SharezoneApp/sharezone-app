import 'package:common_domain_models/common_domain_models.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/homework_completion_status.dart';
import 'package:meta/meta.dart';

import '../date.dart';
import '../subject.dart';
import '../title.dart';

/// The read model of a Homework that is specific to one user.
/// The Homework should only be used to display a homework, created specifically
/// for one user. It should not be edited and put in a repository.
///
/// In Sharezone it used in the context of the HomeworkPage, as it is basically
/// a merge from the information of the homework-details (title, subject, ...)
/// and the specific done status of the user viewing the homework.
class HomeworkReadModel {
  final HomeworkId id;
  final DateTime todoDate;
  final Subject subject;
  final Title title;
  final bool withSubmissions;
  final CompletionStatus status;

  HomeworkReadModel({
    @required this.id,
    @required this.title,
    @required this.subject,
    @required this.status,
    @required this.withSubmissions,
    @required this.todoDate,
  }) {
    ArgumentError.checkNotNull(id);
    ArgumentError.checkNotNull(todoDate);
    ArgumentError.checkNotNull(status);
    ArgumentError.checkNotNull(subject);
    ArgumentError.checkNotNull(withSubmissions);
    ArgumentError.checkNotNull(title);
  }

  @override
  int get hashCode =>
      id.hashCode ^
      todoDate.hashCode ^
      status.hashCode ^
      subject.hashCode ^
      title.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is HomeworkReadModel &&
          id == other.id &&
          title == other.title &&
          subject == other.subject &&
          status == other.status &&
          todoDate == other.todoDate;

  bool isOverdueRelativeTo(Date today) {
    return Date.fromDateTime(todoDate) < today;
  }

  @override
  String toString() {
    return 'Homework(Id: $id, title: $title, subject: $subject, todoDate: $todoDate, done: $status)';
  }
}
