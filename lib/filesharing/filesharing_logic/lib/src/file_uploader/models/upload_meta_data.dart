// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

class UploadMetadata {
  /// Custom metadata set on this storage object.
  final Map<String, dynamic>? customMetadata;

  /// The size of this object, in bytes.
  final int? sizeBytes;

  const UploadMetadata({
    this.customMetadata,
    this.sizeBytes,
  });
}
