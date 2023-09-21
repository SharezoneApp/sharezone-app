// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/local_file.dart';

/// Represents an edited image that is returned by the image editor page.
class EditedImage {
  /// The selected quality of the image.
  final ImageQuality imageQuality;

  /// The edited image.
  final LocalFile localFile;

  const EditedImage({
    required this.imageQuality,
    required this.localFile,
  });
}

enum ImageQuality {
  /// The image should be uploaded in its original quality.
  original,

  /// The image should be compressed before uploading.
  compressed,
}
