// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'implementation/mobile_firebase_file_uploader.dart' as implementation;

import 'file_uploader.dart';

FileUploader getFileUploader() {
  return implementation.getFileUploaderImplementation();
}
