// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:files_basics/files_models.dart';

class CreatedSubmissionsPageView {
  final List<CreatedSubmissionView> submissions;
  final List<CreatedSubmissionView> afterDeadlineSubmissions;
  final List<NotSubmittedView> missingSubmissions;

  const CreatedSubmissionsPageView({
    required this.submissions,
    required this.missingSubmissions,
    required this.afterDeadlineSubmissions,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is CreatedSubmissionsPageView &&
        listEquals(other.submissions, submissions) &&
        listEquals(other.afterDeadlineSubmissions, afterDeadlineSubmissions) &&
        listEquals(other.missingSubmissions, missingSubmissions);
  }

  @override
  int get hashCode =>
      submissions.hashCode ^
      afterDeadlineSubmissions.hashCode ^
      missingSubmissions.hashCode;

  @override
  String toString() =>
      'CreatedSubmissionsPageView(submissions: $submissions, afterDeadlineSubmissions: $afterDeadlineSubmissions, missingSubmissions: $missingSubmissions)';
}

class CreatedSubmissionView {
  final String abbreviation;
  final String username;

  final List<CreatedFileView> submittedFiles;

  /// Wann an der Abgabe zuletzt etwas gemacht wurde.
  /// Das beinhaltet hochladen, neue Dateien hinzufügen, eine Datei löschen etc
  final DateTime lastActionDateTime;

  /// Ob die Abgabe die erste ist oder Dateien nachträglich bearbeitet (neu
  /// hinzugefügt oder gelöscht) wurden.
  final bool wasEditedAfterwards;

  const CreatedSubmissionView({
    required this.abbreviation,
    required this.username,
    required this.submittedFiles,
    required this.lastActionDateTime,
    required this.wasEditedAfterwards,
  });
}

class NotSubmittedView {
  final String abbreviation;
  final String username;

  const NotSubmittedView({
    required this.abbreviation,
    required this.username,
  });
}

class CreatedFileView {
  final String id;
  final FileFormat format;
  final String title;
  final String downloadUrl;

  const CreatedFileView({
    required this.id,
    required this.format,
    required this.title,
    required this.downloadUrl,
  });
}
