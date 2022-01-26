// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:files_usecases/file_saver.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/filesharing/models/sheet_option.dart';
import 'package:sharezone/filesharing/widgets/download_unknown_file_type_dialog_content.dart';
import 'package:sharezone/filesharing/widgets/move_file_page.dart';
import 'package:sharezone/report/page/report_page.dart';
import 'package:sharezone/report/report_item.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/form.dart';
import 'package:sharezone_widgets/snackbars.dart';

Future<void> selectCloudFileAction({
  @required BuildContext context,
  @required SheetOption sheetOption,
  @required CloudFile cloudFile,
  bool popIfDelete = false,
}) async {
  if (sheetOption == null) return;
  final api = BlocProvider.of<SharezoneContext>(context).api;
  cloudFile = await api.fileSharing.cloudFilesGateway
      .cloudFileStream(cloudFile.id)
      .first;
  switch (sheetOption) {
    case SheetOption.download:
      if (PlatformCheck.isWeb) {
        showStartedDownloadSnackBar(context, cloudFile.downloadURL);
        getFileSaver().saveFromUrl(
            cloudFile.downloadURL, cloudFile.name, cloudFile.fileFormat);
      } else {
        showDialog(
          context: context,
          builder: (context) => DownloadUnknownFileTypeDialogContent(
            downloadURL: cloudFile.downloadURL,
            id: cloudFile.id,
            name: cloudFile.name,
            nameStream:
                api.fileSharing.cloudFilesGateway.nameStream(cloudFile.id),
          ),
        );
      }
      break;
    case SheetOption.rename:
      final basename =
          cloudFile.name.substring(0, cloudFile.name.lastIndexOf('.'));
      final extension = cloudFile.name.substring(
          cloudFile.name.lastIndexOf('.') + 1, cloudFile.name.length);
      showDialog(
        context: context,
        builder: (context) => OneTextFieldDialog(
          actionName: "Umbenennen".toUpperCase(),
          hint: "Neuer Name",
          title: "Datei umbenennen",
          text: basename,
          notAllowedChars: "/",
          onTap: (newBasename) {
            if (isNotEmptyOrNull(newBasename)) {
              final renamedCloudFile =
                  cloudFile.copyWith(name: '$newBasename.$extension');
              api.fileSharing.cloudFilesGateway.renameFile(renamedCloudFile);
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
      openReportPage(context, ReportItemReference.file(cloudFile.id));
      break;
    case SheetOption.delete:
      showDeleteDialog(
        context: context,
        popTwice: false,
        description: Text(
            "Möchtest du wirklich die Datei mit dem Namen: \"${cloudFile.name}\" löschen?"),
        title: "Datei löschen?",
        onDelete: () {
          api.fileSharing.cloudFilesGateway
              .deleteFile(cloudFile.courseID, cloudFile.id);
          if (popIfDelete == true) Navigator.pop(context);
        },
      );
      break;
  }
}

void showStartedDownloadSnackBar(BuildContext context, String downloadURL) {
  showSnackSec(
    context: context,
    text:
        "Download wurde gestartet. Sollte der Download nicht automatisch starten, kann der Link zur Datei kopiert werden.",
    seconds: 5,
    behavior: SnackBarBehavior.fixed,
    action: SnackBarAction(
      label: 'Link kopieren'.toUpperCase(),
      onPressed: () {
        _copyDownloadUrlToClipboard(downloadURL);
        _confirmCopiedDownloadUrlSnackBar(context);
      },
    ),
  );
}

void _copyDownloadUrlToClipboard(String downloadURL) {
  Clipboard.setData(ClipboardData(text: downloadURL));
}

void _confirmCopiedDownloadUrlSnackBar(BuildContext context) {
  showSnackSec(
    context: context,
    behavior: SnackBarBehavior.fixed,
    text:
        'Der Download-Link wurde kopiert. Öffne diesen in einem neuen Tab, um den Download zu starten',
  );
}
