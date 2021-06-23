import 'dart:typed_data';

import 'package:files_basics/files_models.dart';

abstract class FileSaver {
  Future<bool> saveFromUrl(String url, String filename, FileFormat fileType);

  Future<String> downloadAndReturnObjectUrl(String url);
  Future<Uint8List> downloadAndReturnBytes(String url);
}
