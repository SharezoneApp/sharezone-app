// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:files_basics/files_models.dart';
import 'package:meta/meta.dart';
import 'package:optional/optional.dart';

class SubmissionPageView {
  final SubmissionDeadlineState deadlineState;
  final bool submitted;
  final List<FileView> files;
  final bool submittable;

  SubmissionPageView({
    @required this.deadlineState,
    @required this.files,
    @required this.submittable,
    @required this.submitted,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is SubmissionPageView &&
        o.deadlineState == deadlineState &&
        o.submitted == submitted &&
        listEquals(o.files, files);
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
  final Optional<String> path;
  String get name => '$basename.$extentionName';
  final String basename;

  /// Ohne Punkt z.B. "pdf"
  final String extentionName;
  final FileFormat fileFormat;
  final FileViewStatus status;
  final Optional<double> uploadProgess;
  final Optional<String> downloadUrl;

  FileView({
    @required this.id,
    @required this.extentionName,
    @required this.basename,
    @required this.status,
    @required this.fileFormat,
    String path,
    double uploadProgess,
    String downloadUrl,
  })  : uploadProgess = Optional.ofNullable(uploadProgess),
        path = Optional.ofNullable(path),
        downloadUrl = Optional.ofNullable(downloadUrl);

  @override
  String toString() {
    return '$runtimeType($name status: $status, path: $path, uploadProgess: $uploadProgess)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FileView &&
        o.path == path &&
        o.basename == basename &&
        o.extentionName == extentionName &&
        o.fileFormat == fileFormat &&
        o.status == status &&
        o.uploadProgess == uploadProgess &&
        o.downloadUrl == downloadUrl;
  }

  @override
  int get hashCode {
    return path.hashCode ^
        basename.hashCode ^
        extentionName.hashCode ^
        fileFormat.hashCode ^
        status.hashCode ^
        uploadProgess.hashCode ^
        downloadUrl.hashCode;
  }
}

enum FileViewStatus {
  /// Die Abgabe wurde noch nicht gestartet
  unitiated,
  uploading,
  succesfullyUploaded,
  failed,
}
