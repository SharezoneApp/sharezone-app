// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:hausaufgabenheft_logik/src/shared/models/homework_completion_status.dart';

import 'date.dart';
import 'subject.dart';
import 'title.dart';

abstract class BaseHomeworkReadModel extends Equatable {
  final HomeworkId id;
  final DateTime todoDate;
  final Subject subject;
  final Title title;
  final CourseId courseId;
  final bool withSubmissions;

  @override
  List<Object?> get props =>
      [id, todoDate, subject, courseId, title, withSubmissions];

  const BaseHomeworkReadModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.courseId,
    required this.withSubmissions,
    required this.todoDate,
  });

  bool isOverdueRelativeTo(Date today) {
    return Date.fromDateTime(todoDate) < today;
  }
}

class StudentHomeworkReadModel extends BaseHomeworkReadModel {
  final CompletionStatus status;

  @override
  List<Object?> get props =>
      [id, todoDate, subject, courseId, title, withSubmissions, status];

  const StudentHomeworkReadModel({
    required super.id,
    required super.title,
    required super.subject,
    required this.status,
    required super.withSubmissions,
    required super.todoDate,
    required super.courseId,
  });
}

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
        courseId,
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
    required super.courseId,
    required super.withSubmissions,
    required super.todoDate,
  });
}

enum ArchivalStatus { open, archived }
