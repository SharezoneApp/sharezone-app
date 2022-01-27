// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/filesharing/models/cloud_file_action.dart';
import 'package:sharezone/filesharing/models/sheet_option.dart';
import 'package:sharezone/report/report_icon.dart';

List<CloudFileAction> folderActions(
    bool isFolderDeletable, bool hasPermissionToEdit) {
  return [
    if (hasPermissionToEdit)
      CloudFileAction(
        name: "Umbenennen",
        iconData: Icons.edit,
        sheetOption: SheetOption.rename,
      ),
    if (hasPermissionToEdit)
      CloudFileAction(
        name: "Löschen",
        iconData: Icons.delete,
        sheetOption: SheetOption.delete,
        enabled: isFolderDeletable,
      ),
  ];
}

List<CloudFileAction> cloudFileActions(bool hasPermissionToEdit) {
  return [
    CloudFileAction(
      name: "Herunterladen",
      iconData: Icons.file_download,
      sheetOption: SheetOption.download,
    ),
    if (hasPermissionToEdit)
      CloudFileAction(
        name: "Umbenennen",
        iconData: Icons.edit,
        sheetOption: SheetOption.rename,
      ),
    if (hasPermissionToEdit)
      CloudFileAction(
        name: "Verschieben nach",
        iconData: Icons.input,
        sheetOption: SheetOption.moveFile,
      ),
    CloudFileAction(
      name: "Melden",
      iconData: reportIcon.icon,
      sheetOption: SheetOption.report,
    ),
    if (hasPermissionToEdit)
      CloudFileAction(
        name: "Löschen",
        iconData: Icons.delete,
        sheetOption: SheetOption.delete,
      ),
  ];
}

List<Widget> cloudFileActionsForAppBar({
  BuildContext context,
  bool hasPermissionToEdit,
  Function(BuildContext context, SheetOption sheetOption)
      onSelectCloudFileAction,
}) {
  return cloudFileActions(hasPermissionToEdit).map((cloudFileAction) {
    return IconButton(
      tooltip: cloudFileAction.name,
      icon: Icon(cloudFileAction.iconData),
      onPressed: () =>
          onSelectCloudFileAction(context, cloudFileAction.sheetOption),
    );
  }).toList();
}

class FolderActionsColumn extends StatelessWidget {
  final bool isFolderDeletable;
  final bool hasPermissionsToEdit;
  final Function(BuildContext context, SheetOption sheetOption)
      onSelectFolderAction;

  const FolderActionsColumn(
      {Key key,
      this.isFolderDeletable,
      this.onSelectFolderAction,
      this.hasPermissionsToEdit})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (final cloudFileAction
            in folderActions(isFolderDeletable, hasPermissionsToEdit))
          ListTile(
            title: Text(cloudFileAction.name),
            leading: Icon(cloudFileAction.iconData),
            onTap: () =>
                onSelectFolderAction(context, cloudFileAction.sheetOption),
            enabled: cloudFileAction.enabled,
          )
      ],
    );
  }
}

class CloudFileActionsColumn extends StatelessWidget {
  final bool hasPermissionToEdit;
  final Function(BuildContext context, SheetOption sheetOption)
      onSelectCloudFileAction;

  const CloudFileActionsColumn(
      {Key key, this.hasPermissionToEdit, this.onSelectCloudFileAction})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (final cloudFileAction in cloudFileActions(hasPermissionToEdit))
          ListTile(
            title: Text(cloudFileAction.name),
            leading: Icon(cloudFileAction.iconData),
            onTap: () =>
                onSelectCloudFileAction(context, cloudFileAction.sheetOption),
          )
      ],
    );
  }
}

class CloudFileActionsRow extends StatelessWidget {
  final bool hasPermissionToEdit;
  final Function(BuildContext context, SheetOption sheetOption)
      onSelectCloudFileAction;

  const CloudFileActionsRow(
      {Key key, this.hasPermissionToEdit, this.onSelectCloudFileAction})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (final cloudFileAction in cloudFileActions(hasPermissionToEdit))
          IconButton(
            tooltip: cloudFileAction.name,
            icon: Icon(cloudFileAction.iconData),
            onPressed: () =>
                onSelectCloudFileAction(context, cloudFileAction.sheetOption),
          )
      ],
    );
  }
}
