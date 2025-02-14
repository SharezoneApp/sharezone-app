// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/local_file.dart';
import 'package:files_basics/local_file_data.dart';
import 'package:http/http.dart' as http;

import '../file_downloader.dart';

class WebFileDownloader extends FileDownloader {
  @override
  Future<LocalFile> downloadFileFromURL(
    String url,
    String filename,
    String id,
  ) async {
    final response = await http.get(Uri.parse(url));
    return LocalFileData.fromData(response.bodyBytes, url, filename, null);
  }
}

FileDownloader getFileDownloader() {
  return WebFileDownloader();
}
