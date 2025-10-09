// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/local_file.dart';
import 'package:file_picker/file_picker.dart' as web;
import 'package:files_basics/local_file_data.dart';

import '../file_picker_implementation.dart';

class FilePickerHtml extends FilePickerImplementation {
  @override
  Future<LocalFile?> pickFile() => _pickSingle();

  @override
  Future<LocalFile?> pickFileImage() => _pickSingle();

  @override
  Future<LocalFile?> pickFileVideo() => _pickSingle();
  @override
  Future<List<LocalFile>?> pickMultiFile() => _pickMulti();

  @override
  Future<List<LocalFile>?> pickMultiFileImage() => _pickMulti();
  @override
  Future<List<LocalFile>?> pickMultiFileVideo() => _pickMulti();

  @override
  Future<LocalFile?> pickImageCamera() => _pickSingle();
  @override
  Future<LocalFile?> pickImageGallery() => _pickSingle();

  Future<LocalFile?> _pickSingle() async {
    final res =
        (await web.FilePicker.platform.pickFiles(
          allowMultiple: false,
          compressionQuality: 30,
        ))!;
    if (res.files.isNotEmpty) {
      final file = res.files.single;

      return LocalFileData.fromData(
        file.bytes!,
        file.path!,
        file.name,
        file.extension!,
      );
    }
    return null;
  }

  Future<List<LocalFile>?> _pickMulti() async {
    final res =
        (await web.FilePicker.platform.pickFiles(
          allowMultiple: true,
          compressionQuality: 30,
        ))!;
    if (res.files.isNotEmpty) {
      return res.files
          .map(
            (file) => LocalFileData.fromData(
              file.bytes!,
              null,
              file.name,
              file.extension!,
            ),
          )
          .toList();
    }
    return null;
  }
}

FilePickerImplementation getFilePickerImplementation() {
  return FilePickerHtml();
}
