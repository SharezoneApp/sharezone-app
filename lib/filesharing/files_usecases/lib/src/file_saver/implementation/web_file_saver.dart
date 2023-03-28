// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// ignore:avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';
import 'package:files_basics/files_models.dart';
import 'package:files_usecases/src/file_saver/file_saver.dart';

class WebFileSaver extends FileSaver {
  @override
  Future<bool> saveFromUrl(
      String url, String filename, FileFormat fileType) async {
    final newUrl = await downloadAndReturnObjectUrl(url);
    final anchorElement = AnchorElement(href: newUrl);
    anchorElement.download = filename;
    anchorElement.click();
    return true;
  }

  @override
  Future<String> downloadAndReturnObjectUrl(String url) async {
    final request = await HttpRequest.request(url, responseType: 'blob');
    final data = request.response;
    final newUrl = Url.createObjectUrlFromBlob(data);
    return newUrl;
  }

  @override
  Future<Uint8List> downloadAndReturnBytes(String url) async {
    final request = await HttpRequest.request(url, responseType: 'arraybuffer');
    final ByteBuffer data = request.response;

    return data.asUint8List();
  }
}

FileSaver getFileSaver() {
  return WebFileSaver();
}
