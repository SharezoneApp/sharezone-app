// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:files_basics/files_models.dart';

class SubmissionPageView {
  final SubmissionDeadlineState deadlineState;
  final bool submitted;
  final List<FileView> files;
  final bool submittable;

  const SubmissionPageView({
    required this.deadlineState,
    required this.files,
    required this.submittable,
    required this.submitted,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is SubmissionPageView &&
        other.deadlineState == deadlineState &&
        other.submitted == submitted &&
        listEquals(other.files, files);
  }

  @override
  int get hashCode =>
      deadlineState.hashCode ^ submitted.hashCode ^ files.hashCode;

  @override
  String toString() =>
      'SubmissionPageView(state: $deadlineState, submitted: $submitted, files: $files)';
}

enum SubmissionDeadlineState {
  beforeDeadline,
  onDeadline,
  afterDeadline,
}

class FileView {
  final String id;
  final String? path;
  String get name => '$basename.$extentionName';
  final String basename;

  /// Ohne Punkt z.B. "pdf"
  final String extentionName;
  final FileFormat fileFormat;
  final FileViewStatus status;
  final double? uploadProgress;
  final String? downloadUrl;

  FileView({
    required this.id,
    required this.extentionName,
    required this.basename,
    required this.status,
    required this.fileFormat,
    this.path,
    this.uploadProgress,
    this.downloadUrl,
  });

  @override
  String toString() {
    return '$runtimeType($name status: $status, path: $path, uploadProgess: $uploadProgress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FileView &&
        other.path == path &&
        other.basename == basename &&
        other.extentionName == extentionName &&
        other.fileFormat == fileFormat &&
        other.status == status &&
        other.uploadProgress == uploadProgress &&
        other.downloadUrl == downloadUrl;
  }

  @override
  int get hashCode {
    return path.hashCode ^
        basename.hashCode ^
        extentionName.hashCode ^
        fileFormat.hashCode ^
        status.hashCode ^
        uploadProgress.hashCode ^
        downloadUrl.hashCode;
  }
}

enum FileViewStatus {
  /// Die Abgabe wurde noch nicht gestartet
  unitiated,
  uploading,
  successfullyUploaded,
  failed,
}
