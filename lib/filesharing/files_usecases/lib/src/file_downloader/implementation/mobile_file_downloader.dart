// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/local_file.dart';
import 'package:files_basics/local_file_io.dart';
import 'package:files_usecases/src/file_downloader/file_downloader.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MobileFileDownloader extends FileDownloader {
  @override
  Future<LocalFile> downloadFileFromURL(
    String url,
    String filename,
    String id,
  ) async {
    final file = await DefaultCacheManager().getSingleFile(url);
    return LocalFileIo.fromFile(file);
  }
}

FileDownloader getFileDownloader() {
  return MobileFileDownloader();
}
