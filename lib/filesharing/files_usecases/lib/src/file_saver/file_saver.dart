// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:typed_data';

abstract class FileSaver {
  Future<String>? downloadAndReturnObjectUrl(String? url);
  Future<Uint8List>? downloadAndReturnBytes(String url);
}
