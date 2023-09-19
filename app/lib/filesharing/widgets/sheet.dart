// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:files_basics/files_models.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/file_sharing/file_sharing_page_bloc.dart';
import 'package:sharezone/filesharing/logic/select_cloud_file_action.dart';
import 'package:sharezone/filesharing/logic/select_folder_action.dart';
import 'package:sharezone/filesharing/models/sheet_option.dart';
import 'package:sharezone/filesharing/rules/filesharing_permissions.dart';
import 'package:sharezone/filesharing/widgets/cloud_file_actions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'cloud_file_icon.dart';

Future<void> showFolderSheet({
  required Folder folder,
  required BuildContext context,
  required bool hasPermissions,
  required FolderPath? path,
  String? courseID,
}) async {
  final option = await showModalBottomSheet<SheetOption>(
    context: context,
    builder: (context) => FileSheet(
      name: folder.name,
      creatorName: folder.creatorName,
      icon: Icon(Icons.folder, color: Colors.grey[600]),
      items: FolderActionsColumn(
        hasPermissionsToEdit: hasPermissions,
        isFolderDeletable: folder.isDeletable(path!),
        onSelectFolderAction: (context, sheetOption) {
          Navigator.pop(context, sheetOption);
        },
      ),
    ),
  );
  if (!context.mounted) return;

  await selectFolderAction(
    context: context,
    courseID: courseID,
    folder: folder,
    sheetOption: option,
    path: path,
  );
}

Future<void> showCloudFileSheet({
  required CloudFile cloudFile,
  required BuildContext context,
  required FileSharingPageBloc bloc,
}) async {
  final hasPermissionToEdit =
      FileSharingPermissionsNoSync.fromContext(context).canManageCloudFile(
    cloudFile: cloudFile,
  );
  final option = await showModalBottomSheet<SheetOption>(
    context: context,
    builder: (context) => FileSheet(
      name: cloudFile.name,
      icon: FileIcon(fileFormat: cloudFile.fileFormat),
      creatorName: cloudFile.creatorName,
      sizeBytes: cloudFile.sizeBytes,
      items: CloudFileActionsColumn(
        hasPermissionToEdit: hasPermissionToEdit,
        onSelectCloudFileAction: (context, sheetOption) =>
            Navigator.pop(context, sheetOption),
      ),
    ),
  );
  if (!context.mounted) return;

  await selectCloudFileAction(
    cloudFile: cloudFile,
    sheetOption: option,
    context: context,
  );
}

class FileSheet extends StatelessWidget {
  const FileSheet({
    Key? key,
    this.items,
    required this.name,
    required this.creatorName,
    this.fileType,
    this.icon,
    this.sizeBytes,
  }) : super(key: key);

  final String? name;
  final String? creatorName;
  final Widget? items;
  final FileFormat? fileType;
  final Widget? icon;
  final int? sizeBytes;

  @override
  Widget build(BuildContext context) {
    final TextStyle greyTextStyle = TextStyle(
        color: Theme.of(context).isDarkTheme
            ? Colors.grey[400]
            : Colors.grey[600]);
    final api = BlocProvider.of<SharezoneContext>(context).api;
    return SafeArea(
      left: true,
      right: true,
      bottom: true,
      child: BlocProvider<FileSharingPageBloc>(
          bloc: FileSharingPageBloc(api.fileSharing),
          child: Builder(
            builder: (context) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 8, 2),
                      child: Row(
                        children: <Widget>[
                          icon!,
                          const SizedBox(width: 32),
                          Flexible(
                            child: Text(name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 72, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Ersteller: $creatorName",
                            style: greyTextStyle,
                          ),
                          sizeBytes != null
                              ? Text(
                                  "Größe: ${KiloByteSize(bytes: sizeBytes!).inMegabytes.toStringAsFixed(2)} MB",
                                  style: greyTextStyle,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    items!,
                  ],
                ),
              );
            },
          )),
    );
  }
}
