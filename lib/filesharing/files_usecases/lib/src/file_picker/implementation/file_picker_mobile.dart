// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:collection/collection.dart'
    show IterableExtension, IterableNullableExtension;
import 'package:file_picker/file_picker.dart';
import 'package:file_picker/file_picker.dart' as mobile_file_picker;
import 'package:files_basics/local_file.dart';
import 'package:files_basics/local_file_io.dart';
import 'package:image_picker/image_picker.dart' as mobile_image_picker;
import 'package:sharezone_utils/platform.dart';

import '../file_picker_implementation.dart';
import 'file_picker_desktop.dart' as desktop;

class MobileFilePicker extends FilePickerImplementation {
  LocalFile? _fileOrNull(PlatformFile? file) {
    if (file == null) {
      return null;
    }
    return LocalFileIo.fromFile(File(file.path!));
  }

  Future<PlatformFile?> _pickSinglePlatformFileOrNull(
      [mobile_file_picker.FileType type =
          mobile_file_picker.FileType.any]) async {
    final files = (await mobile_file_picker.FilePicker.platform
        .pickFiles(type: type, allowMultiple: false));
    return files?.files.firstOrNull;
  }

  Future<LocalFile?> _pickSingleFileOrNull(
      [mobile_file_picker.FileType type =
          mobile_file_picker.FileType.any]) async {
    return _fileOrNull(await _pickSinglePlatformFileOrNull(type));
  }

  Future<List<PlatformFile>> _pickMultiPlatformFilesOrNull(
      [mobile_file_picker.FileType type =
          mobile_file_picker.FileType.any]) async {
    final files = (await mobile_file_picker.FilePicker.platform
        .pickFiles(type: type, allowMultiple: true));
    return files?.files ?? [];
  }

  Future<List<LocalFile>> _pickMultiFilesOrNull(
      [mobile_file_picker.FileType type =
          mobile_file_picker.FileType.any]) async {
    final platformFiles = await _pickMultiPlatformFilesOrNull(type);
    return platformFiles.map(_fileOrNull).whereNotNull().toList();
  }

  @override
  Future<LocalFile?> pickFile() async {
    return _pickSingleFileOrNull(mobile_file_picker.FileType.any);
  }

  @override
  Future<LocalFile?> pickFileImage() async {
    return _pickSingleFileOrNull(mobile_file_picker.FileType.image);
  }

  @override
  Future<LocalFile?> pickFileVideo() async {
    return _pickSingleFileOrNull(mobile_file_picker.FileType.video);
  }

  @override
  Future<List<LocalFile>> pickMultiFile() async {
    return _pickMultiFilesOrNull(mobile_file_picker.FileType.any);
  }

  @override
  Future<List<LocalFile>> pickMultiFileImage() async {
    return _pickMultiFilesOrNull(mobile_file_picker.FileType.image);
  }

  @override
  Future<List<LocalFile>> pickMultiFileVideo() async {
    return _pickMultiFilesOrNull(mobile_file_picker.FileType.video);
  }

  @override
  Future<LocalFile?> pickImageCamera() async {
    final pickedFile = await mobile_image_picker.ImagePicker()
        .pickImage(source: mobile_image_picker.ImageSource.camera);
    if (pickedFile != null) return LocalFileIo.fromFile(File(pickedFile.path));
    return null;
  }

  @override
  Future<LocalFile?> pickImageGallery() async {
    final pickedFile = await mobile_image_picker.ImagePicker()
        .pickImage(source: mobile_image_picker.ImageSource.camera);
    if (pickedFile != null) return LocalFileIo.fromFile(File(pickedFile.path));
    return null;
  }
}

FilePickerImplementation getFilePickerImplementation() {
  if (PlatformCheck.isDesktop) return desktop.getFilePickerImplementation();
  return MobileFilePicker();
}
