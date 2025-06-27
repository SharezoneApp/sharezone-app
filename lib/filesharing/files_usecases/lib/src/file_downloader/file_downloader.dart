// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/local_file.dart';

abstract class FileDownloader {
  /// Downloads a file from the given [url], saves it locally and returns a
  /// [LocalFile] representing the downloaded file.
  ///
  /// Renames to [filename], if [rename] is `true`.
  Future<LocalFile> downloadFileFromURL(
    String url,
    String filename,
    String id, {
    bool rename = true,
  });
}
