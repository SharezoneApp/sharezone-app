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
import 'package:sharezone/blocs/file_sharing/file_sharing_page_bloc.dart';
import 'package:sharezone/filesharing/logic/file_sharing_page_state_bloc.dart';
import 'package:sharezone/filesharing/models/file_sharing_page_state.dart';
import 'package:sharezone/filesharing/rules/filesharing_permissions.dart';
import 'package:sharezone/widgets/animation/color_fade_in.dart';
import 'package:sharezone_utils/dimensions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'logic/open_cloud_file.dart';
import 'widgets/card_with_icon_and_text.dart';
import 'widgets/cloud_file_icon.dart';
import 'widgets/filesharing_headline.dart';
import 'widgets/sheet.dart';

class FileSharingViewGroup extends StatelessWidget {
  const FileSharingViewGroup({
    required this.groupState,
  });

  final FileSharingPageStateGroup? groupState;

  FileSharingData? get initialData => groupState!.initialFileSharingData;

  FolderPath get path => groupState!.path;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FileSharingPageBloc>(context);
    return StreamBuilder<FileSharingData>(
      initialData: initialData,
      stream: bloc.courseFolder(initialData!.courseID),
      builder: (context, snapshot) {
        final fileSharingData = snapshot.data;
        if (fileSharingData == null) {
          return Center(child: AccentColorCircularProgressIndicator());
        }
        final folders = fileSharingData.getFolders(path)!.values.toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.only(left: 8, top: 8),
          child: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  key: ValueKey(path),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _FolderGrid(
                      courseID: fileSharingData.courseID,
                      fileSharingData: fileSharingData,
                      folders: folders,
                      path: path,
                    ),
                    _FileGrid(
                      courseID: initialData!.courseID,
                      path: path,
                      folderNumber: folders.length,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FolderGrid extends StatelessWidget {
  const _FolderGrid({
    this.folders,
    this.fileSharingData,
    this.courseID,
    this.path,
  });

  final List<Folder>? folders;
  final FileSharingData? fileSharingData;
  final String? courseID;
  final FolderPath? path;

  @override
  Widget build(BuildContext context) {
    if (folders != null && folders!.isEmpty) return Container();
    folders!.sort((a, b) => a.name!.compareTo(b.name!));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const FileSharingHeadline(title: "Ordner"),
        WrappableList(
          minWidth: 150.0,
          maxElementsPerSection: 3,
          children: [
            for (final folder in folders!)
              _FolderCard(
                folder: folder,
                fileSharingData: fileSharingData,
                path: path,
              ),
          ],
        ),
      ],
    );
  }
}

class _FileGrid extends StatelessWidget {
  const _FileGrid({
    Key? key,
    required this.courseID,
    required this.path,
    this.folderNumber = 0,
  }) : super(key: key);

  final String courseID;
  final FolderPath path;
  final int folderNumber;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FileSharingPageBloc>(context);
    return StreamBuilder<List<CloudFile>>(
      stream: bloc.fileQuery(courseID, path),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        if (snapshot.data!.isEmpty && folderNumber == 0) return _NoFilesFound();
        if (snapshot.data!.isEmpty) return Container();
        final files = snapshot.data!;
        files.sort((a, b) => a.name.compareTo(b.name));
        return ColorFadeIn(
          color: Colors.transparent,
          duration: const Duration(milliseconds: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const FileSharingHeadline(title: "Dateien"),
              WrappableList(
                minWidth: 150.0,
                maxElementsPerSection: 3,
                children: <Widget>[
                  for (final file in files)
                    _FileCard(
                      cloudFile: file,
                      courseId: courseID,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FolderCard extends StatelessWidget {
  const _FolderCard({
    required this.folder,
    required this.path,
    this.fileSharingData,
  });

  final Folder folder;
  final FolderPath? path;
  final FileSharingData? fileSharingData;

  @override
  Widget build(BuildContext context) {
    return CardWithIconAndText(
      onTap: () {
        final stateBloc = BlocProvider.of<FileSharingPageStateBloc>(context);

        final newState = FileSharingPageStateGroup(
          groupID: fileSharingData!.courseID,
          path: path!.getChildPath(folder.id),
          initialFileSharingData: fileSharingData,
        );
        stateBloc.changeStateTo(newState);
      },
      icon: Icon(Icons.folder, color: Colors.grey[600]),
      text: folder.name ?? "?",
      trailing: folder.id != "attachment"
          ? IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => showFolderSheet(
                courseID: fileSharingData!.courseID,
                path: path,
                folder: folder,
                context: context,
                hasPermissions:
                    FileSharingPermissionsNoSync.fromContext(context)
                        .canManageFolder(
                            courseID: fileSharingData!.courseID,
                            folder: folder),
              ),
            )
          : null,
    );
  }
}

class _FileCard extends StatelessWidget {
  const _FileCard({
    required this.cloudFile,
    required this.courseId,
  });

  final CloudFile cloudFile;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FileSharingPageBloc>(context);
    return CardWithIconAndText(
      icon: FileIcon(fileFormat: cloudFile.fileFormat),
      text: cloudFile.name,
      onTap: () => openCloudFilePage(context, cloudFile, courseId),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () => showCloudFileSheet(
          cloudFile: cloudFile,
          context: context,
          bloc: bloc,
        ),
      ),
    );
  }
}

class _NoFilesFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions.fromMediaQuery(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height -
          (dimensions.isDesktopModus ? 100 : 200),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 48),
        child: PlaceholderWidgetWithAnimation(
          svgPath: "assets/icons/folder.svg",
          animateSVG: true,
          title: "Keine Dateien gefunden 😶",
          description: const Text(
              "Lade jetzt einfach eine Datei hoch, um diese mit deinem Kurs zu teilen 👍"),
        ),
      ),
    );
  }
}
