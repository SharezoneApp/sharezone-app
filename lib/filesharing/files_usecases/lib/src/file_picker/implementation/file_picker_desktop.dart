import 'dart:io';

import 'package:files_basics/local_file.dart';
import 'package:files_basics/local_file_io.dart';
import 'package:file_chooser/file_chooser.dart' as file_chooser;
import '../file_picker_implementation.dart';

class FilePickerDesktop extends FilePickerImplementation {
  @override
  Future<LocalFile> pickFile() async {
    return selectSingleFile();
  }

  @override
  Future<LocalFile> pickFileImage() async {
    return selectSingleFile();
  }

  @override
  Future<LocalFile> pickFileVideo() async {
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
  Future<LocalFile> pickImageCamera() async {
    return selectSingleFile();
  }

  @override
  Future<LocalFile> pickImageGallery() async {
    return selectSingleFile();
  }
}

Future<List<LocalFile>> selectMultipleFiles() async {
  final fileChooserResult =
      await file_chooser.showOpenPanel(allowsMultipleSelection: true);
  if (fileChooserResult.canceled) return [];
  final files =
      fileChooserResult.paths.map((path) => LocalFileIo.fromFile(File(path)));
  return files.toList();
}

Future<LocalFile> selectSingleFile() async {
  final fileChooserResult =
      await file_chooser.showOpenPanel(allowsMultipleSelection: false);
  if (fileChooserResult.canceled) return null;
  final files =
      fileChooserResult.paths.map((path) => LocalFileIo.fromFile(File(path)));
  return files.toList()[0];
}

FilePickerImplementation getFilePickerImplementation() {
  return FilePickerDesktop();
}
