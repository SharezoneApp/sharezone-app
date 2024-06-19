// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:hausaufgabenheft_logik/src/models/homework_completion_status.dart';

import 'date.dart';
import 'subject.dart';
import 'title.dart';

abstract class BaseHomeworkReadModel extends Equatable {
  final HomeworkId id;
  final DateTime todoDate;
  final Subject subject;
  final Title title;
  final bool withSubmissions;

  @override
  List<Object?> get props => [id, todoDate, subject, title, withSubmissions];

  const BaseHomeworkReadModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.withSubmissions,
    required this.todoDate,
  });

  bool isOverdueRelativeTo(Date today) {
    return Date.fromDateTime(todoDate) < today;
  }
}

/// The read model of a Homework that is specific to one user.
/// The Homework should only be used to display a homework, created specifically
/// for one user. It should not be edited and put in a repository.
///
/// In Sharezone it used in the context of the HomeworkPage, as it is basically
/// a merge from the information of the homework-details (title, subject, ...)
/// and the specific done status of the user viewing the homework.
class StudentHomeworkReadModel extends BaseHomeworkReadModel {
  final CompletionStatus status;

  @override
  List<Object?> get props =>
      [id, todoDate, subject, title, withSubmissions, status];

  const StudentHomeworkReadModel({
    required super.id,
    required super.title,
    required super.subject,
    required this.status,
    required super.withSubmissions,
    required super.todoDate,
  });
}

/// Ein ReadModel für die Lehrer-Hausaufgaben-Seite.
/// Siehe [StudentHomeworkReadModel].
class TeacherHomeworkReadModel extends BaseHomeworkReadModel {
  final ArchivalStatus status;
  final int nrOfStudentsCompleted;
  final bool canViewCompletions;
  final bool canViewSubmissions;

  /// If the user has the permission to delete the homework for everyone in the
  /// group.
  final bool canDeleteForEveryone;

  /// If the user has the permission to edit the homework for everyone in the
  /// group.
  final bool canEditForEveryone;

  @override
  List<Object?> get props => [
        id,
        todoDate,
        subject,
        title,
        withSubmissions,
        status,
        nrOfStudentsCompleted,
        canViewCompletions,
        canViewSubmissions,
        canDeleteForEveryone,
        canEditForEveryone,
      ];

  const TeacherHomeworkReadModel({
    required this.nrOfStudentsCompleted,
    required this.canViewCompletions,
    required this.canViewSubmissions,
    required this.canDeleteForEveryone,
    required this.canEditForEveryone,
    required this.status,
    required super.id,
    required super.title,
    required super.subject,
    required super.withSubmissions,
    required super.todoDate,
  });
}

enum ArchivalStatus { open, archived }
