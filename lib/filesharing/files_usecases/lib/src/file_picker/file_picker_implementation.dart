// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/local_file.dart';

abstract class FilePickerImplementation {
  Future<LocalFile> pickFile();
  Future<LocalFile> pickFileImage();
  Future<LocalFile> pickFileVideo();
  Future<List<LocalFile>> pickMultiFile();
  Future<List<LocalFile>> pickMultiFileImage();
  Future<List<LocalFile>> pickMultiFileVideo();
  Future<LocalFile> pickImageGallery();
  Future<LocalFile> pickImageCamera();
}
