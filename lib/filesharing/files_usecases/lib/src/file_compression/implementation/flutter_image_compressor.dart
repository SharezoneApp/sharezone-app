// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:io';

import 'package:files_basics/local_file.dart';
import 'package:files_basics/local_file_io.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../image_compressor.dart';

class FlutterImageCompressor extends ImageCompressor {
  @override
  Future<LocalFile?> compressImage(LocalFile file) async {
    final File ioFile = file.getFile();
    final dir = await getTemporaryDirectory();
    final targetPath = "${dir.absolute.path}/compressed-${file.getName()}";
    final result = await FlutterImageCompress.compressAndGetFile(
      ioFile.absolute.path,
      targetPath,
      quality: 90,
    );
    if (result == null) return null;

    final fileFromXFile = File(result.path);
    return LocalFileIo.fromFile(fileFromXFile);
  }
}

ImageCompressor getImageCompressor() {
  return FlutterImageCompressor();
}
