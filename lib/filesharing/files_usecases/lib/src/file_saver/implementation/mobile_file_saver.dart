import 'dart:typed_data';

import 'package:files_basics/files_models.dart';
import 'package:files_usecases/src/file_saver/file_saver.dart';

class MobileFileSaver extends FileSaver {
  @override
  Future<bool> saveFromUrl(
      String url, String filename, FileFormat extensionType) async {
    return false;
  }

  @override
  Future<String> downloadAndReturnObjectUrl(String url) {
    return null;
  }

  @override
  Future<Uint8List> downloadAndReturnBytes(String url) {
    return null;
  }
}

FileSaver getFileSaver() {
  return MobileFileSaver();
}
