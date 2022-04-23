// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:filesharing_logic/filesharing_logic_models.dart';

abstract class FolderOperator {
  Future<void> createFolder(
      String courseID, FolderPath folderPath, Folder folder);
  Future<void> renameFolder(
      String courseID, FolderPath folderPath, Folder folder);
  Future<void> deleteFolder(
      String courseID, FolderPath folderPath, Folder folder);
  Future<void> editFolder(
      String courseID, FolderPath folderPath, Folder folder);
}
