import 'package:files_basics/local_file.dart';

import 'file_picker_implementation.dart';
import 'implementation/stub_file_picker.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'implementation/file_picker_mobile.dart'
    if (dart.library.js) 'implementation/file_picker_html.dart'
    as implementation;

class FilePicker {
  final FilePickerImplementation _implementation;

  FilePicker._(this._implementation);

  factory FilePicker() {
    return FilePicker._(implementation.getFilePickerImplementation());
  }

  Future<LocalFile> pickFile() => _implementation.pickFile();
  Future<LocalFile> pickFileImage() => _implementation.pickFileImage();
  Future<LocalFile> pickFileVideo() => _implementation.pickFileVideo();
  Future<List<LocalFile>> pickMultiFile() => _implementation.pickMultiFile();
  Future<List<LocalFile>> pickMultiFileImage() =>
      _implementation.pickMultiFileImage();
  Future<List<LocalFile>> pickMultiFileVideo() =>
      _implementation.pickMultiFileVideo();
  Future<LocalFile> pickImageGallery() => _implementation.pickImageGallery();
  Future<LocalFile> pickImageCamera() => _implementation.pickImageCamera();
}
