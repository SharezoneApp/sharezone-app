// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/abgabe_client_lib.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/filesharing/logic/open_cloud_file.dart';
import 'package:sharezone/filesharing/logic/select_cloud_file_action.dart';

void openCreateSubmissionFile(BuildContext context, FileView view) {
  if (view.downloadUrl != null) {
    openFirestoreFilePage(
      context: context,
      fileFormat: view.fileFormat,
      actions: [
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed:
              () => saveFileOnDevice(
                context: context,
                downloadUrl: view.downloadUrl!,
                fileId: view.id,
                fileName: view.name,
              ),
        ),
      ],
      downloadURL: view.downloadUrl,
      id: view.id,
      name: view.name,
    );
  }
}

void openAbgegebeneAbgabedatei(BuildContext context, CreatedFileView view) {
  openFirestoreFilePage(
    context: context,
    fileFormat: view.format,
    actions: [
      IconButton(
        icon: const Icon(Icons.file_download),
        onPressed:
            () => saveFileOnDevice(
              context: context,
              downloadUrl: view.downloadUrl,
              fileId: view.id,
              fileName: view.title,
            ),
      ),
    ],
    downloadURL: view.downloadUrl,
    id: view.id,
    name: view.title,
  );
}
