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
import 'package:sharezone/filesharing/logic/move_file_bloc.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class MoveFilePageHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final FolderPath currentPath;
  final FileSharingData fileSharingData;

  const MoveFilePageHeader({Key key, this.currentPath, this.fileSharingData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          Icons.home,
          color: currentPath == FolderPath.root
              ? Theme.of(context).primaryColor
              : null,
        ),
        onPressed: () {
          if (currentPath == FolderPath.root) {
            showSnackSec(
              context: context,
              text:
                  'Ein Verschieben zu einem anderen Kurs ist aktuell noch nicht möglich.',
            );
          } else {
            final moveFileBloc = BlocProvider.of<MoveFileBloc>(context);
            moveFileBloc.changeNewPath(FolderPath.root);
          }
        },
      ),
      title: _FileSharingPathRow(
        fileSharingData: fileSharingData,
        path: currentPath,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}

class _FileSharingPathRow extends StatelessWidget {
  final FileSharingData fileSharingData;
  final FolderPath path;

  const _FileSharingPathRow({Key key, this.fileSharingData, this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pathHierachy = path.getPathsHierachy();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: pathHierachy.map((subPath) {
          return _ClickableElement(
            isLast: subPath == path,
            text: _getTextSubPath(context, fileSharingData, subPath) ?? '',
            onTap: () {
              // if(path == FolderPaths.ROOT)
              final moveFileBloc = BlocProvider.of<MoveFileBloc>(context);

              moveFileBloc.changeNewPath(subPath);
            },
          );
        }).toList(),
      ),
    );
  }

  String _getTextSubPath(BuildContext context, FileSharingData fileSharingData,
      FolderPath subPath) {
    if (subPath == FolderPath.root) return fileSharingData.courseName;
    return fileSharingData.getFolder(subPath)?.name;
  }
}

class _ClickableElement extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isLast;

  const _ClickableElement({Key key, this.onTap, this.text, this.isLast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.chevron_right,
            color: isLast ? Theme.of(context).primaryColor : null,
            size: 28,
          ),
          Text(
            text,
            style: TextStyle(
                color: isLast ? Theme.of(context).primaryColor : null),
          ),
        ],
      ),
      borderRadius: BorderRadius.circular(8),
      onTap: isLast ? null : onTap,
    );
  }
}
