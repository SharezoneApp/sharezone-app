// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/abgabe_client_lib.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_usecases/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/filesharing/logic/open_cloud_file.dart';
import 'package:sharezone/filesharing/logic/select_cloud_file_action.dart';
import 'package:sharezone/filesharing/widgets/download_unknown_file_type_dialog_content.dart';
import 'package:sharezone_utils/platform.dart';

void openCreateSubmissionFile(BuildContext context, FileView view) {
  if (view.downloadUrl.isPresent) {
    openFirestoreFilePage(
      context: context,
      fileFormat: view.fileFormat,
      actions: [
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: () => _downloadFile(
            context: context,
            downloadUrl: view.downloadUrl.value,
            fileId: view.id,
            fileName: view.name,
            format: view.fileFormat,
          ),
        )
      ],
      downloadURL: view.downloadUrl.value,
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
        onPressed: () => _downloadFile(
          context: context,
          downloadUrl: view.downloadUrl,
          fileId: view.id,
          fileName: view.title,
          format: view.format,
        ),
      )
    ],
    downloadURL: view.downloadUrl,
    id: view.id,
    name: view.title,
  );
}

void _downloadFile({
  required BuildContext context,
  required String downloadUrl,
  required String fileName,
  required FileFormat format,
  required String fileId,
}) {
  // Bei der Web-App wird die Datei direkt über den Browser heruntergeladen,
  // weswegen kein Lade-Dialog notwendig ist (Lade-Dialog wird vom Browser
  // übernommen).
  if (PlatformCheck.isWeb) {
    showStartedDownloadSnackBar(context, downloadUrl);
    getFileSaver()!.saveFromUrl(downloadUrl, fileName, format);
  } else {
    showDialog(
      context: context,
      builder: (context) => DownloadUnknownFileTypeDialogContent(
        downloadURL: downloadUrl,
        name: fileName,
        id: fileId,
        nameStream: Stream.value(fileName),
      ),
    );
  }
}
