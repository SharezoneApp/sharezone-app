// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'upload_meta_data.dart';

class UploadTaskSnapshot {
  final UploadMetadata storageMetaData;

  /// The current transferred bytes of this task.
  final int bytesTransferred;

  /// The total bytes of the task.
  /// Note; when performing a download task, the value of -1 will be provided whilst the total size of the remote file is being determined.
  final int totalByteCount;

  // Im Web nicht verfügbar!
  final Future<dynamic> Function() getDownloadUrl;
  const UploadTaskSnapshot({
    this.storageMetaData,
    this.bytesTransferred,
    this.totalByteCount,
    this.getDownloadUrl,
  });
}
