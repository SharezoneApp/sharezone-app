import 'dart:io';

import 'package:files_basics/local_file.dart';
import 'package:files_basics/local_file_io.dart';
import 'package:file_picker/file_picker.dart' as mobile_file_picker;
import 'package:image_picker/image_picker.dart' as mobile_image_picker;
import 'file_picker_desktop.dart' as desktop;
import 'package:sharezone_utils/platform.dart';
import '../file_picker_implementation.dart';

class MobileFilePicker extends FilePickerImplementation {
  @override
  Future<LocalFile> pickFile() async {
    final ioFile = await mobile_file_picker.FilePicker.getFile(
        type: mobile_file_picker.FileType.any);
    if (ioFile != null) return LocalFileIo.fromFile(ioFile);
    return null;
  }

  @override
  Future<LocalFile> pickFileImage() async {
    final ioFile = await mobile_file_picker.FilePicker.getFile(
        type: mobile_file_picker.FileType.image);

    if (ioFile != null) return LocalFileIo.fromFile(ioFile);
    return null;
  }

  @override
  Future<LocalFile> pickFileVideo() async {
    final ioFile = await mobile_file_picker.FilePicker.getFile(
        type: mobile_file_picker.FileType.video);

    if (ioFile != null) return LocalFileIo.fromFile(ioFile);
    return null;
  }

  @override
  Future<List<LocalFile>> pickMultiFile() async {
    final ioFiles = await mobile_file_picker.FilePicker.getMultiFile(
        type: mobile_file_picker.FileType.any);

    if (ioFiles != null)
      return ioFiles.map((ioFile) => LocalFileIo.fromFile(ioFile)).toList();
    return null;
  }

  @override
  Future<List<LocalFile>> pickMultiFileImage() async {
    final ioFiles = await mobile_file_picker.FilePicker.getMultiFile(
        type: mobile_file_picker.FileType.image);

    if (ioFiles != null)
      return ioFiles.map((ioFile) => LocalFileIo.fromFile(ioFile)).toList();
    return null;
  }

  @override
  Future<List<LocalFile>> pickMultiFileVideo() async {
    final ioFiles = await mobile_file_picker.FilePicker.getMultiFile(
        type: mobile_file_picker.FileType.video);

    if (ioFiles != null)
      return ioFiles.map((ioFile) => LocalFileIo.fromFile(ioFile)).toList();
    return null;
  }

  @override
  Future<LocalFile> pickImageCamera() async {
    final pickedFile = await mobile_image_picker.ImagePicker()
        .getImage(source: mobile_image_picker.ImageSource.camera);
    if (pickedFile != null) return LocalFileIo.fromFile(File(pickedFile.path));
    return null;
  }

  @override
  Future<LocalFile> pickImageGallery() async {
    final pickedFile = await mobile_image_picker.ImagePicker()
        .getImage(source: mobile_image_picker.ImageSource.gallery);
    if (pickedFile != null) return LocalFileIo.fromFile(File(pickedFile.path));
    return null;
  }
}

FilePickerImplementation getFilePickerImplementation() {
  if (PlatformCheck.isDesktop) return desktop.getFilePickerImplementation();
  return MobileFilePicker();
}
