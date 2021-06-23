import 'package:files_basics/local_file.dart';

import '../image_compressor.dart';

class NoImageCompressor extends ImageCompressor {
  @override
  Future<LocalFile> compressImage(LocalFile file) {
    return Future.value(file);
  }
}

ImageCompressor getImageCompressor() {
  return NoImageCompressor();
}
