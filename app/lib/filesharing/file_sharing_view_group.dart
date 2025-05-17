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
import 'package:sharezone/filesharing/bloc/file_sharing_page_bloc.dart';
import 'package:sharezone/filesharing/logic/file_sharing_page_state_bloc.dart';
import 'package:sharezone/filesharing/models/file_sharing_page_state.dart';
import 'package:sharezone/filesharing/rules/filesharing_permissions.dart';
import 'package:sharezone/filesharing/widgets/card_with_icon_and_text.dart';
import 'package:sharezone/filesharing/widgets/file_grird_card.dart';
import 'package:sharezone/filesharing/widgets/file_list_card.dart';
import 'package:sharezone/filesharing/widgets/filesharing_headline.dart';
import 'package:sharezone/filesharing/widgets/sheet.dart';
import 'package:sharezone/widgets/animation/color_fade_in.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FileSharingViewGroup extends StatelessWidget {
  const FileSharingViewGroup({super.key, required this.groupState});

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
          return const Center(child: AccentColorCircularProgressIndicator());
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
                    // Even though files can be displayed as a list and a grid,
                    // we always display them as a grid (Google Drive does the
                    // same).
                    _FolderGrid(
                      courseID: fileSharingData.courseID,
                      fileSharingData: fileSharingData,
                      folders: folders,
                      path: path,
                    ),
                    _Files(
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

class _Files extends StatelessWidget {
  const _Files({
    required this.courseID,
    required this.path,
    this.folderNumber = 0,
  });

  final String courseID;
  final FolderPath path;
  final int folderNumber;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FileSharingPageBloc>(context);
    final stateBloc = BlocProvider.of<FileSharingPageStateBloc>(context);
    final viewMode =
        stateBloc.currentStateValue is FileSharingPageStateGroup
            ? (stateBloc.currentStateValue as FileSharingPageStateGroup)
                .viewMode
            : defaultViewMode;

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
              if (viewMode == FileSharingViewMode.grid)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: files.length,
                  itemBuilder:
                      (context, index) => FileGridCard(
                        cloudFile: files[index],
                        courseId: courseID,
                      ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: files.length,
                    itemBuilder:
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: FileListCard(
                            file: files[index],
                            courseID: courseID,
                            bloc: bloc,
                          ),
                        ),
                  ),
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
      trailing:
          folder.id != "attachment"
              ? IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed:
                    () => showFolderSheet(
                      courseID: fileSharingData!.courseID,
                      path: path,
                      folder: folder,
                      context: context,
                      hasPermissions: FileSharingPermissionsNoSync.fromContext(
                        context,
                      ).canManageFolder(
                        courseID: fileSharingData!.courseID,
                        folder: folder,
                      ),
                    ),
              )
              : null,
    );
  }
}

class _NoFilesFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions.fromMediaQuery(context);
    return SizedBox(
      height:
          MediaQuery.of(context).size.height -
          (dimensions.isDesktopModus ? 100 : 200),
      child: const Padding(
        padding: EdgeInsets.only(bottom: 48),
        child: PlaceholderWidgetWithAnimation(
          svgPath: "assets/icons/folder.svg",
          animateSVG: true,
          title: "Keine Dateien gefunden 😶",
          description: Text(
            "Lade jetzt einfach eine Datei hoch, um diese mit deinem Kurs zu teilen 👍",
          ),
        ),
      ),
    );
  }
}
