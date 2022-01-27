// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'file_saver.dart';
import 'implementation/stub_file_saver.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'implementation/mobile_file_saver.dart'
    if (dart.library.js) 'implementation/web_file_saver.dart' as implementation;

FileSaver getFileSaver() {
  return implementation.getFileSaver();
}
