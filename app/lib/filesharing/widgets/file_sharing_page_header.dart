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
import 'package:provider/provider.dart';
import 'package:sharezone/filesharing/logic/file_sharing_page_state_bloc.dart';
import 'package:sharezone/filesharing/models/file_sharing_page_state.dart';
import 'package:sharezone/filesharing/widgets/view_mode_toggle.dart';
import 'package:key_value_store/key_value_store.dart';

class FileSharingPageHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final FileSharingPageState? pageState;

  const FileSharingPageHeader({super.key, this.pageState});

  @override
  Widget build(BuildContext context) {
    if (pageState is FileSharingPageStateGroup) {
      final groupState = pageState as FileSharingPageStateGroup;

      return Row(
        children: [
          Expanded(
            child: ListTile(
              leading: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  final stateBloc = BlocProvider.of<FileSharingPageStateBloc>(
                    context,
                  );
                  final newState = FileSharingPageStateHome();
                  stateBloc.changeStateTo(newState);
                },
              ),
              title: _FileSharingPathRow(
                fileSharingData: groupState.initialFileSharingData,
                path: groupState.path,
              ),
            ),
          ),
          ViewModeToggle(
            viewMode: groupState.viewMode,
            onViewModeChanged: (viewMode) {
              if (pageState is FileSharingPageStateGroup) {
                final stateBloc = BlocProvider.of<FileSharingPageStateBloc>(
                  context,
                );
                final currentState = pageState as FileSharingPageStateGroup;
                stateBloc.changeStateTo(
                  currentState.copyWith(viewMode: viewMode),
                );
                setViewModeToCache(context.read<KeyValueStore>(), viewMode);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      );
    }
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.home, color: Theme.of(context).primaryColor),
        onPressed: null,
      ),
      title: _getTitleOverview(context),
    );
  }

  Widget _getTitleOverview(BuildContext context) {
    return Text(
      "Kursordner",
      style: TextStyle(color: Theme.of(context).primaryColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _FileSharingPathRow extends StatelessWidget {
  final FileSharingData? fileSharingData;
  final FolderPath? path;

  const _FileSharingPathRow({this.fileSharingData, this.path});
  @override
  Widget build(BuildContext context) {
    final pathHierachy = path!.getPathsHierachy();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            pathHierachy.map((subPath) {
              return _ClickableElement(
                isLast: subPath == path,
                text: _getTextSubPath(context, fileSharingData, subPath),
                onTap: () {
                  final stateBloc = BlocProvider.of<FileSharingPageStateBloc>(
                    context,
                  );
                  final newState = FileSharingPageStateGroup(
                    groupID: fileSharingData!.courseID,
                    initialFileSharingData: fileSharingData,
                    path: subPath,
                    viewMode: getViewModeFromCache(
                      context.read<KeyValueStore>(),
                    ),
                  );
                  stateBloc.changeStateTo(newState);
                },
              );
            }).toList(),
      ),
    );
  }

  String? _getTextSubPath(
    BuildContext context,
    FileSharingData? fileSharingData,
    FolderPath subPath,
  ) {
    if (subPath == FolderPath.root) return fileSharingData!.courseName;
    return fileSharingData!.getFolder(subPath)!.name;
  }
}

class _ClickableElement extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;
  final bool? isLast;

  const _ClickableElement({this.onTap, this.text, this.isLast});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: isLast! ? null : onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.chevron_right,
            color: isLast! ? Theme.of(context).primaryColor : null,
            size: 28,
          ),
          Text(
            text!,
            style: TextStyle(
              color: isLast! ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
}
