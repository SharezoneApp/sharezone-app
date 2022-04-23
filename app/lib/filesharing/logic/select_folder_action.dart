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
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/filesharing/models/sheet_option.dart';
import 'package:sharezone_widgets/form.dart';

Future<void> selectFolderAction({
  @required BuildContext context,
  @required SheetOption sheetOption,
  @required Folder folder,
  @required String courseID,
  @required FolderPath path,
}) async {
  if (sheetOption == null) return;
  final api = BlocProvider.of<SharezoneContext>(context).api;
  switch (sheetOption) {
    case SheetOption.rename:
      showDialog(
        context: context,
        builder: (context) => OneTextFieldDialog(
          actionName: "Umbenennen".toUpperCase(),
          hint: "Neuer Name",
          title: "Ordner umbenennen",
          text: folder.name,
          onTap: (name) {
            final renamedFolder = folder.copyWith(name: name);
            api.fileSharing.folderGateway
                .renameFolder(courseID, path, renamedFolder);
            Navigator.pop(context);
          },
        ),
      );
      break;
    case SheetOption.delete:
      showDeleteDialog(
        context: context,
        popTwice: false,
        description: Text(
            "Möchtest du wirklich den Ordner mit dem Namen \"${folder.name}\" löschen?"),
        title: "Ordner löschen?",
        onDelete: () =>
            api.fileSharing.folderGateway.deleteFolder(courseID, path, folder),
      );
      break;
    default:
      break;
  }
}
