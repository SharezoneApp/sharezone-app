// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'image_compressor.dart';
import 'implementation/stub_image_compressor.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'implementation/flutter_image_compressor.dart'
    as implementation;

ImageCompressor getImageCompressor() {
  return implementation.getImageCompressor();
}
