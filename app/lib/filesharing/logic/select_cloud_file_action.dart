// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone/filesharing/models/sheet_option.dart';
import 'package:sharezone/filesharing/widgets/download_unknown_file_type_dialog_content.dart';
import 'package:sharezone/filesharing/widgets/move_file_page.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/report/page/report_page.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> selectCloudFileAction({
  required BuildContext context,
  required SheetOption? sheetOption,
  required CloudFile cloudFile,
  bool popIfDelete = false,
}) async {
  if (sheetOption == null) return;
  final api = BlocProvider.of<SharezoneContext>(context).api;
  cloudFile =
      await api.fileSharing.cloudFilesGateway
          .cloudFileStream(cloudFile.id!)
          .first;
  if (!context.mounted) return;

  switch (sheetOption) {
    case SheetOption.download:
      saveFileOnDevice(
        context: context,
        downloadUrl: cloudFile.downloadURL,
        fileId: cloudFile.id,
        fileName: cloudFile.name,
      );
      break;
    case SheetOption.rename:
      final basename = cloudFile.name.substring(
        0,
        cloudFile.name.lastIndexOf('.'),
      );
      final extension = cloudFile.name.substring(
        cloudFile.name.lastIndexOf('.') + 1,
        cloudFile.name.length,
      );
      showDialog(
        context: context,
        builder:
            (context) => OneTextFieldDialog(
              actionName: "Umbenennen".toUpperCase(),
              hint: "Neuer Name",
              title: "Datei umbenennen",
              text: basename,
              notAllowedChars: "/",
              onTap: (newBasename) {
                if (isNotEmptyOrNull(newBasename)) {
                  final renamedCloudFile = cloudFile.copyWith(
                    name: '$newBasename.$extension',
                  );
                  api.fileSharing.cloudFilesGateway.renameFile(
                    renamedCloudFile,
                  );
                  Navigator.pop(context);
                }
              },
            ),
      );
      break;
    case SheetOption.moveFile:
      openMoveFilePage(context: context, cloudFile: cloudFile);
      break;
    case SheetOption.report:
      openReportPage(context, ReportItemReference.file(cloudFile.id!));
      break;
    case SheetOption.delete:
      showDeleteDialog(
        context: context,
        popTwice: false,
        description: Text(
          "Möchtest du wirklich die Datei mit dem Namen: \"${cloudFile.name}\" löschen?",
        ),
        title: "Datei löschen?",
        onDelete: () {
          api.fileSharing.cloudFilesGateway.deleteFile(
            cloudFile.courseID!,
            cloudFile.id!,
          );
          if (popIfDelete == true) Navigator.pop(context);
        },
      );
      break;
  }
}

void _showStartedDownloadSnackBar(BuildContext context) {
  showSnackSec(context: context, text: "Download wurde gestartet...");
}

void _showBrokenFileSnackBar(BuildContext context) {
  showSnackSec(
    context: context,
    text: 'Die Datei ist beschädigt und kann nicht heruntergeladen werden.',
  );
}

void saveFileOnDevice({
  required BuildContext context,
  required String? downloadUrl,
  required String? fileId,
  required String? fileName,
}) {
  if (downloadUrl == null) {
    _showBrokenFileSnackBar(context);
    return;
  }

  // For non-iOS platforms, simply open the download URL in your browser.
  // This automatically downloads the file to the device's downloads folder
  // and uses the file name from the Content-Disposition header.
  if (!PlatformCheck.isIOS) {
    _showStartedDownloadSnackBar(context);
    launchUrl(
      Uri.parse(downloadUrl),
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
    return;
  }

  // There is no typical download folder for iOS. It's more common to simply
  // open the share dialogue. From there, users can click 'Save to Files' to
  // save the file in the Files app, or select a different action (e.g. save
  // the file in the Photos app).
  showDialog(
    context: context,
    builder:
        (context) => DownloadUnknownFileTypeDialogContent(
          downloadURL: downloadUrl,
          id: fileId,
          name: fileName,
          nameStream: Stream.value(fileName ?? ''),
          action: FileHandlingAction.shareFile,
        ),
  );
}
