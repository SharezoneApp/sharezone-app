// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/local_file.dart';

import 'file_picker_implementation.dart';
import 'implementation/stub_file_picker.dart'
    if (dart.library.io) 'implementation/file_picker_mobile.dart'
    if (dart.library.js) 'implementation/file_picker_html.dart'
    as implementation;

class FilePicker {
  final FilePickerImplementation? _implementation;

  FilePicker._(this._implementation);

  factory FilePicker() {
    return FilePicker._(implementation.getFilePickerImplementation());
  }

  Future<LocalFile?> pickFile() => _implementation!.pickFile();
  Future<LocalFile?> pickFileImage() => _implementation!.pickFileImage();
  Future<LocalFile?> pickFileVideo() => _implementation!.pickFileVideo();
  Future<List<LocalFile>?> pickMultiFile() => _implementation!.pickMultiFile();
  Future<List<LocalFile>?> pickMultiFileImage() =>
      _implementation!.pickMultiFileImage();
  Future<List<LocalFile>?> pickMultiFileVideo() =>
      _implementation!.pickMultiFileVideo();
  Future<LocalFile?> pickImageGallery() => _implementation!.pickImageGallery();
  Future<LocalFile?> pickImageCamera() => _implementation!.pickImageCamera();
}
