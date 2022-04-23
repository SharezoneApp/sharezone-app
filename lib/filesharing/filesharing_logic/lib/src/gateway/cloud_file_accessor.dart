// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:filesharing_logic/filesharing_logic_models.dart';

abstract class CloudFileAccessor {
  Stream<List<CloudFile>> filesStreamFolder(String courseID, FolderPath path);

  Stream<List<CloudFile>> filesStreamFolderAndSubFolders(
      String courseID, FolderPath path);

  Stream<List<CloudFile>> filesStreamAttachment(
      String courseID, String referenceID);

  Stream<CloudFile> cloudFileStream(String cloudFileID);

  Stream<String> nameStream(String cloudFileID);
}
