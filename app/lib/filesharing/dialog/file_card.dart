// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/filesharing/widgets/cloud_file_icon.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

Future<void> showRemoveFileFromBlocDialog({
  required BuildContext context,
  required VoidCallback removeFileFromBlocMethod,
}) async {
  FocusManager.instance.primaryFocus?.unfocus(); // Closing keyboard
  await Future.delayed(const Duration(milliseconds: 200));
  if (!context.mounted) return;

  showDialog(
    context: context,
    builder:
        (context) => SimpleDialog(
          contentPadding: const EdgeInsets.all(0),
          children: <Widget>[
            LongPressDialogTile(
              iconData: Icons.delete,
              title: "Anhang entfernen",
              onTap: () {
                removeFileFromBlocMethod();
                Navigator.pop(context);
              },
            ),
          ],
        ),
  );
}

class FileCard extends StatelessWidget {
  final LocalFile? localFile;
  final CloudFile? cloudFile;

  final Widget? trailing;
  final VoidCallback? onTap, onLongPress;

  const FileCard({
    super.key,
    this.localFile,
    this.cloudFile,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) => FileTile(
    cloudFile: cloudFile,
    localFile: localFile,
    trailing: trailing,
    onTap: onTap,
    onLongPress: onLongPress,
  );
}

class FileTile extends StatelessWidget {
  final LocalFile? localFile;
  final CloudFile? cloudFile;

  final Widget? trailing;
  final VoidCallback? onTap, onLongPress;

  const FileTile({
    super.key,
    required this.cloudFile,
    this.localFile,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final FileFormat fileType =
        localFile != null
            ? FileUtils.getFileFormatFromMimeType(localFile!.getType())
            : cloudFile!.fileFormat;
    final name = localFile != null ? localFile!.getName() : cloudFile!.name;

    return FileTileBase(
      name: name,
      fileType: fileType,
      onTap: onTap,
      trailing: trailing,
      onLongPress: onLongPress,
    );
  }
}

class FileTileBase extends StatelessWidget {
  const FileTileBase({
    super.key,
    required this.name,
    required this.fileType,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  final String name;
  final FileFormat fileType;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FileIcon(fileFormat: fileType),
      title: Text(name),
      onTap: onTap,
      trailing: trailing,
      onLongPress: onLongPress,
    );
  }
}

class FileMoreOptionsWithOnlyRemoveFileFromBloc extends StatelessWidget {
  const FileMoreOptionsWithOnlyRemoveFileFromBloc({
    super.key,
    required this.removeFileFromBlocMethod,
  });

  final VoidCallback removeFileFromBlocMethod;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed:
          () => showRemoveFileFromBlocDialog(
            context: context,
            removeFileFromBlocMethod: removeFileFromBlocMethod,
          ),
    );
  }
}
