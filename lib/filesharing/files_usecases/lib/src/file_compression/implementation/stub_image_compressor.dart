// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
