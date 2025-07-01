// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:js_interop';
import 'dart:typed_data';

import 'package:files_usecases/src/file_saver/file_saver.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart';

class WebFileSaver extends FileSaver {
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
