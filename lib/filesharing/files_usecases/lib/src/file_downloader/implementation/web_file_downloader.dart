// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:files_basics/local_file.dart';
import 'package:files_basics/local_file_data.dart';

import '../file_downloader.dart';

class WebFileDownloader extends FileDownloader {
  @override
  Future<LocalFile> downloadFileFromURL(
      String url, String filename, String id) async {
    final request = await HttpRequest.request(url, responseType: 'arraybuffer');
    final ByteBuffer buffer = request.response;
    final data = buffer.asUint8List();
    return LocalFileData.fromData(data, url, filename, null);
  }
}

FileDownloader getFileDownloader() {
  return WebFileDownloader();
}
