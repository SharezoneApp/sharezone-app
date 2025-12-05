// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';
import 'dart:io';

import 'package:files_basics/local_file.dart';
import 'package:files_basics/local_file_io.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import '../file_picker_implementation.dart';

class FilePickerDesktop extends FilePickerImplementation {
  @override
  Future<LocalFile?> pickFile() async {
    return selectSingleFile();
  }

  @override
  Future<LocalFile?> pickFileImage() async {
    return selectSingleFile();
  }

  @override
  Future<LocalFile?> pickFileVideo() async {
    return selectSingleFile();
  }

  @override
  Future<List<LocalFile>> pickMultiFile() async {
    return selectMultipleFiles();
  }

  @override
  Future<List<LocalFile>> pickMultiFileImage() async {
    return selectMultipleFiles();
  }

  @override
  Future<List<LocalFile>> pickMultiFileVideo() async {
    return selectMultipleFiles();
  }

  @override
  Future<LocalFile?> pickImageCamera() async {
    return selectSingleFile();
  }

  @override
  Future<LocalFile?> pickImageGallery() async {
    return selectSingleFile();
  }
}

Future<List<LocalFile>> selectMultipleFiles() async {
  final fileChooserResult = (await file_picker.FilePicker.platform.pickFiles(
    allowMultiple: true,
    compressionQuality: 30,
  ));
  if (fileChooserResult == null || fileChooserResult.count == 0) return [];
  log('fileChooserResult.paths: ${fileChooserResult.paths}');
  final files = fileChooserResult.paths.map(
    (path) => LocalFileIo.fromFile(File(path!)),
  );
  return files.toList();
}

Future<LocalFile?> selectSingleFile() async {
  final fileChooserResult = (await file_picker.FilePicker.platform.pickFiles(
    allowMultiple: false,
    compressionQuality: 30,
  ));
  if (fileChooserResult == null || fileChooserResult.count == 0) return null;
  final files = fileChooserResult.paths.map(
    (path) => LocalFileIo.fromFile(File(path!)),
  );
  return files.toList()[0];
}

FilePickerImplementation getFilePickerImplementation() {
  return FilePickerDesktop();
}
