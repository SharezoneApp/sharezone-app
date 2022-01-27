// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:path/path.dart';
import 'mime_type.dart';
import 'local_file.dart';

class LocalFileIo extends LocalFile {
  final File file;
  final String fileName;
  final String path;
  final MimeType mimeType;
  final int sizeBytes;

  LocalFileIo._(
      {this.file, this.fileName, this.path, this.sizeBytes, this.mimeType});

  factory LocalFileIo.fromFile(File file) {
    if (file == null) return null;
    final fileName = basename(file.path);
    return LocalFileIo._(
      file: file,
      fileName: fileName,
      path: file.path,
      sizeBytes: file.lengthSync(),
      mimeType: MimeType.fromPathOrNull(file.path) ??
          MimeType.fromFileNameOrNull(fileName) ??
          MimeType.any,
    );
  }

  @override
  getFile() {
    return file;
  }

  @override
  MimeType getType() {
    return mimeType;
  }

  @override
  String getName() {
    return fileName;
  }

  @override
  String getPath() {
    return path;
  }

  @override
  getData() {
    return file.readAsBytesSync();
  }

  @override
  int getSizeBytes() {
    return sizeBytes;
  }
}
