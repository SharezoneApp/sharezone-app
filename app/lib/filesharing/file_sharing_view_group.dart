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
import 'package:key_value_store/key_value_store.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/filesharing/bloc/file_sharing_page_bloc.dart';
import 'package:sharezone/filesharing/logic/file_sharing_page_state_bloc.dart';
import 'package:sharezone/filesharing/models/file_sharing_page_state.dart';
import 'package:sharezone/filesharing/rules/filesharing_permissions.dart';
import 'package:sharezone/filesharing/widgets/card_with_icon_and_text.dart';
import 'package:sharezone/filesharing/widgets/file_grid_card.dart';
import 'package:sharezone/filesharing/widgets/file_list_card.dart';
import 'package:sharezone/filesharing/widgets/filesharing_headline.dart';
import 'package:sharezone/filesharing/widgets/sheet.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
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

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: CustomScrollView(
            key: ValueKey(path),
            slivers: [
              SliverSafeArea(
                sliver: SliverPadding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      key: ValueKey(path),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Folders are always displayed as a grid even when files
                        // are displayed as a list (similar to Google Drive's approach).
                        _FolderGrid(
                          courseID: fileSharingData.courseID,
                          fileSharingData: fileSharingData,
                          folders: folders,
                          path: path,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _FilesSliver(
                courseID: initialData!.courseID,
                path: path,
                folderNumber: folders.length,
              ),
            ],
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
        FileSharingHeadline(title: context.l10n.fileSharingFoldersHeadline),
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

class _FilesSliver extends StatelessWidget {
  const _FilesSliver({
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
        if (!snapshot.hasData) {
          return const SliverToBoxAdapter(child: SizedBox());
        }
        if (snapshot.data!.isEmpty && folderNumber == 0) {
          return SliverToBoxAdapter(child: _NoFilesFound());
        }
        if (snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox());
        }

        final files = snapshot.data!;
        files.sort((a, b) => a.name.compareTo(b.name));

        return SliverPadding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          sliver:
              viewMode == FileSharingViewMode.grid
                  ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: () {
                        final width = MediaQuery.of(context).size.width;
                        // Aiming to have:
                        // * Mobile: 2 columns
                        // * Tablet: 3 columns
                        // * Desktop: > 4 columns
                        if (width < 600) {
                          return 2;
                        }
                        return (width / 400).ceil();
                      }(),
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => FileGridCard(
                        cloudFile: files[index],
                        courseId: courseID,
                      ),
                      childCount: files.length,
                    ),
                  )
                  : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: FileListCard(
                          file: files[index],
                          courseID: courseID,
                          bloc: bloc,
                        ),
                      ),
                      childCount: files.length,
                    ),
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
          viewMode: getViewModeFromCache(context.read<KeyValueStore>()),
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
      child: Padding(
        padding: EdgeInsets.only(bottom: 48),
        child: PlaceholderWidgetWithAnimation(
          svgPath: "assets/icons/folder.svg",
          animateSVG: true,
          title: context.l10n.fileSharingNoFilesFoundTitle,
          description: Text(context.l10n.fileSharingNoFilesFoundDescription),
        ),
      ),
    );
  }
}
