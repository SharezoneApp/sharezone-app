// ignore:avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:files_basics/local_file.dart';
import 'package:file_picker_web/file_picker_web.dart' as filePickerWeb;
import 'package:files_basics/local_file_data.dart';

import '../file_picker_implementation.dart';

class FilePickerHtml extends FilePickerImplementation {
  @override
  Future<LocalFile> pickFile() => _pickSingle();

  @override
  Future<LocalFile> pickFileImage() => _pickSingle();

  @override
  Future<LocalFile> pickFileVideo() => _pickSingle();
  @override
  Future<List<LocalFile>> pickMultiFile() => _pickMulti();

  @override
  Future<List<LocalFile>> pickMultiFileImage() => _pickMulti();
  @override
  Future<List<LocalFile>> pickMultiFileVideo() => _pickMulti();

  @override
  Future<LocalFile> pickImageCamera() => _pickSingle();
  @override
  Future<LocalFile> pickImageGallery() => _pickSingle();

  Future<LocalFile> _pickSingle() async {
    final selectedFile = await filePickerWeb.FilePicker.getFile();
    if (selectedFile != null)
      return await localFileDataFromHtmlFile(selectedFile);
    return null;
  }

  Future<List<LocalFile>> _pickMulti() async {
    final selectedFiles = await filePickerWeb.FilePicker.getMultiFile();
    final localFiles = await Future.wait(
        selectedFiles.map((file) => localFileDataFromHtmlFile(file)));
    return localFiles;
  }
}

Future<LocalFileData> localFileDataFromHtmlFile(html.File file) async {
  final reader = html.FileReader();
  reader.readAsArrayBuffer(file);
  await reader.onLoadEnd.first;
  final data = reader.result;
  return LocalFileData.fromData(data, file.relativePath, file.name, file.type);
}

FilePickerImplementation getFilePickerImplementation() {
  return FilePickerHtml();
}
