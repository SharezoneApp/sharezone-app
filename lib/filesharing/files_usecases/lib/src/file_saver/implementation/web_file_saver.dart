// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:js_interop';

import 'package:web/web.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:files_basics/files_models.dart';
import 'package:files_usecases/src/file_saver/file_saver.dart';

class WebFileSaver extends FileSaver {
  @override
  Future<bool> saveFromUrl(
    String url,
    String filename,
    FileFormat fileType,
  ) async {
    final newUrl = await downloadAndReturnObjectUrl(url);

    final anchor = document.createElement('a') as HTMLAnchorElement;
    anchor.href = newUrl;
    anchor.style.display = filename;
    anchor.download = filename;
    document.body!.add(anchor);
    anchor.click();
    anchor.remove();

    return true;
  }

  @override
  Future<String> downloadAndReturnObjectUrl(String? url) async {
    final response = await http.get(Uri.parse(url!));
    final blob = Blob(
      <JSUint8Array>[response.bodyBytes.toJS].toJS,
      BlobPropertyBag(
        type: response.headers['content-type'] ?? 'application/octet-stream',
      ),
    );
    return URL.createObjectURL(blob);
  }

  @override
  Future<Uint8List> downloadAndReturnBytes(String url) async {
    final response = await http.get(Uri.parse(url));

    return response.bodyBytes;
  }
}

FileSaver getFileSaver() {
  return WebFileSaver();
}
