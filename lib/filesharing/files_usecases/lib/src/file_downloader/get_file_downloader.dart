// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'file_downloader.dart';
import 'implementation/stub_file_downloader.dart'
    // ignore: uri_does_not_exist
    if (dart.library.io) 'implementation/mobile_file_downloader.dart'
    if (dart.library.js) 'implementation/web_file_downloader.dart'
    as implementation;

FileDownloader? getFileDownloader() {
  return implementation.getFileDownloader();
}
