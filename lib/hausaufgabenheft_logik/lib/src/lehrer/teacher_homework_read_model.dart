// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/models/homework.dart';

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
