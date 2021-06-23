import 'package:files_basics/local_file.dart';

abstract class FilePickerImplementation {
  Future<LocalFile> pickFile();
  Future<LocalFile> pickFileImage();
  Future<LocalFile> pickFileVideo();
  Future<List<LocalFile>> pickMultiFile();
  Future<List<LocalFile>> pickMultiFileImage();
  Future<List<LocalFile>> pickMultiFileVideo();
  Future<LocalFile> pickImageGallery();
  Future<LocalFile> pickImageCamera();
}
