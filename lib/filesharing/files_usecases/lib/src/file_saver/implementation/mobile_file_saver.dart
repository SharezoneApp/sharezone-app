// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:typed_data';

import 'package:files_usecases/src/file_saver/file_saver.dart';

class MobileFileSaver extends FileSaver {
  @override
  Future<String>? downloadAndReturnObjectUrl(String? url) {
    return null;
  }

  @override
  Future<Uint8List>? downloadAndReturnBytes(String url) {
    return null;
  }
}

FileSaver getFileSaver() {
  return MobileFileSaver();
}
