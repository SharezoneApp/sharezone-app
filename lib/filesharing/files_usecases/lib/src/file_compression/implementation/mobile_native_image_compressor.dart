import 'dart:io';
import 'package:files_basics/local_file.dart';
import 'package:files_basics/local_file_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../image_compressor.dart';

class FlutterNativeImageCompressor extends ImageCompressor {
  @override
  Future<LocalFile> compressImage(LocalFile file) async {
    final File ioFile = file.getFile();
    final dir = await getTemporaryDirectory();
    final targetPath = "${dir.absolute.path}/compressed-${file.getName()}";
    final result = await FlutterImageCompress.compressAndGetFile(
      ioFile.absolute.path,
      targetPath,
      quality: 90,
    );
    if (result == null) return null;
    return LocalFileIo.fromFile(result);
  }
}

ImageCompressor getImageCompressor() {
  return FlutterNativeImageCompressor();
}
