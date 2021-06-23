import 'package:files_basics/local_file.dart';

abstract class ImageCompressor {
  Future<LocalFile> compressImage(LocalFile file);
}
