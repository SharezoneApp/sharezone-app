// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_usecases/file_saver.dart';
import 'package:files_usecases/file_viewer.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/filesharing/logic/select_cloud_file_action.dart';
import 'package:sharezone/filesharing/models/sheet_option.dart';
import 'package:sharezone/filesharing/rules/filesharing_permissions.dart';
import 'package:sharezone/filesharing/widgets/cloud_file_actions.dart';
import 'package:sharezone/filesharing/widgets/download_unknown_file_type_dialog_content.dart';
import 'package:sharezone_utils/platform.dart';

import '../file_page.dart';

void openCloudFilePage(
    BuildContext context, CloudFile cloudFile, String courseID) {
  final api = BlocProvider.of<SharezoneContext>(context).api;

  final hasPermissionToEdit = FileSharingPermissionsNoSync(api)
      .canManageCloudFile(cloudFile: cloudFile);
  final actions = [
    PopupMenuButton<SheetOption>(
      itemBuilder: (context) {
        return cloudFileActions(hasPermissionToEdit).map((cloudFileAction) {
          return PopupMenuItem(
            value: cloudFileAction.sheetOption,
            child: Text(cloudFileAction.name!),
          );
        }).toList();
      },
      onSelected: (selected) {
        selectCloudFileAction(
          cloudFile: cloudFile,
          context: context,
          sheetOption: selected,
          popIfDelete: true,
        );
      },
    ),
  ];

  final id = cloudFile.id;
  openFirestoreFilePage(
    context: context,
    fileFormat: cloudFile.fileFormat,
    actions: actions,
    downloadURL: cloudFile.downloadURL,
    id: id,
    name: cloudFile.name,
    nameStream: api.fileSharing.cloudFilesGateway.nameStream(cloudFile.id!),
  );
}

void openFirestoreFilePage({
  required BuildContext context,
  required FileFormat fileFormat,
  List<Widget>? actions,
  String? downloadURL,
  String? name,
  Stream<String>? nameStream,
  String? id,
}) {
  if (!PlatformCheck.isWeb &&
      (fileFormat == FileFormat.unknown ||
          fileFormat == FileFormat.excel ||
          fileFormat == FileFormat.text ||
          fileFormat == FileFormat.zip ||
          (PlatformCheck.isIOS && fileFormat == FileFormat.pdf))) {
    showDialog(
      context: context,
      builder: (context) => DownloadUnknownFileTypeDialogContent(
        downloadURL: downloadURL,
        name: name,
        id: id,
        nameStream: nameStream,
      ),
    );
  }
  // Die Datei wird im Web gedownloadet, sollten wir keine passende Anzeige (Video/PDF/Bild) haben
  else if (PlatformCheck.isWeb &&
      !(fileFormat == FileFormat.video ||
          fileFormat == FileFormat.image ||
          fileFormat == FileFormat.pdf)) {
    showStartedDownloadSnackBar(context, downloadURL);
    getFileSaver()!.saveFromUrl(downloadURL!, name!, fileFormat);
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FirestoreFilePage(
          id: id,
          downloadURL: downloadURL,
          name: name,
          nameStream: nameStream,
          actions: actions,
          fileFormat: fileFormat,
        ),
        settings: const RouteSettings(name: FirestoreFilePage.tag),
      ),
    );
  }
}

class FirestoreFilePage extends StatelessWidget {
  static const String tag = "remote-file-page";

  const FirestoreFilePage({
    Key? key,
    required this.actions,
    required this.fileFormat,
    this.name,
    this.downloadURL,
    this.nameStream,
    this.id,
  }) : super(key: key);

  final String? id;
  final String? name;
  final String? downloadURL;
  final Stream<String>? nameStream;
  final List<Widget>? actions;
  final FileFormat fileFormat;

  @override
  Widget build(BuildContext context) {
    // IMAGE-FILEPAGE FOR ALL PLATFORMS
    if (fileFormat == FileFormat.image) {
      return ImageFilePage(
        name: name!,
        actions: actions,
        nameStream: nameStream,
        downloadURL: downloadURL!,
        id: id!,
      );
    }

    // Video Page for Android, iOS und Web
    //
    // We just download the video for macOS because the video_player package is
    // not available on macOS yet. Tracking issue:
    // https://github.com/flutter/flutter/issues/41688
    if (fileFormat == FileFormat.video && !PlatformCheck.isMacOS) {
      return VideoFilePage(
        name: name!,
        nameStream: nameStream,
        actions: actions!,
        downloadURL: downloadURL!,
      );
    }

    // Pdf Page für Android & Web
    if ((PlatformCheck.isAndroid || PlatformCheck.isWeb) &&
        fileFormat == FileFormat.pdf) {
      return FilePage(
        downloadURL: downloadURL!,
        id: id!,
        name: name!,
        nameStream: nameStream,
        actions: actions,
        fileType: fileFormat,
      );
    }

    return DownloadUnknownFileFormatPage(
      downloadURL: downloadURL!,
      id: id,
      name: name,
      nameStream: nameStream,
      actions: actions,
    );
  }
}
