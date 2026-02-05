// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_usecases/file_viewer.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone/filesharing/logic/select_cloud_file_action.dart';
import 'package:sharezone/filesharing/models/sheet_option.dart';
import 'package:sharezone/filesharing/rules/filesharing_permissions.dart';
import 'package:sharezone/filesharing/widgets/cloud_file_actions.dart';
import 'package:sharezone/filesharing/widgets/download_unknown_file_type_dialog_content.dart';
import 'package:sharezone/main/application_bloc.dart';

import '../file_page.dart';

void openCloudFilePage(
  BuildContext context,
  CloudFile cloudFile,
  String courseID,
) {
  final api = BlocProvider.of<SharezoneContext>(context).api;

  final hasPermissionToEdit = FileSharingPermissionsNoSync(
    api,
  ).canManageCloudFile(cloudFile: cloudFile);
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
  // Since the native iOS PDF viewer is better than every Flutter PDF viewer
  // package, we download & open the PDF file directly in the native viewer.
  if (PlatformCheck.isIOS && fileFormat == FileFormat.pdf) {
    showDialog(
      context: context,
      builder:
          (context) => DownloadUnknownFileTypeDialogContent(
            downloadURL: downloadURL,
            name: name,
            id: id,
            nameStream: nameStream,
            action: FileHandlingAction.openFile,
          ),
    );
    return;
  }

  final hasInAppViewerSupport = switch (fileFormat) {
    FileFormat.video => true,
    FileFormat.image => true,
    FileFormat.pdf => true,
    _ => false,
  };

  // If we can't display the file in our app, we download it to the device.
  if (!hasInAppViewerSupport) {
    saveFileOnDevice(
      context: context,
      downloadUrl: downloadURL,
      fileId: id,
      fileName: name,
    );
    return;
  }

  openInAppFileViewer(
    context,
    id,
    downloadURL,
    name,
    nameStream,
    actions,
    fileFormat,
  );
}

void openInAppFileViewer(
  BuildContext context,
  String? id,
  String? downloadURL,
  String? name,
  Stream<String>? nameStream,
  List<Widget>? actions,
  FileFormat fileFormat,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (context) => FirestoreFilePage(
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

class FirestoreFilePage extends StatelessWidget {
  static const String tag = "remote-file-page";

  const FirestoreFilePage({
    super.key,
    required this.actions,
    required this.fileFormat,
    this.name,
    this.downloadURL,
    this.nameStream,
    this.id,
  });

  final String? id;
  final String? name;
  final String? downloadURL;
  final Stream<String>? nameStream;
  final List<Widget>? actions;
  final FileFormat fileFormat;

  @override
  Widget build(BuildContext context) {
    if (downloadURL == null) {
      return ErrorFilePage(
        name: name,
        nameStream: nameStream,
        error: Text(
          "Die Datei ist scheint beschädigt zu sein. Lösche sie bitte und lade sie erneut hoch.",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

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

    if (fileFormat == FileFormat.video) {
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
