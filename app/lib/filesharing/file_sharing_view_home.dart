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
import 'package:sharezone/widgets/animation/color_fade_in.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

// ignore:implementation_imports
import 'logic/file_sharing_page_state_bloc.dart';
import 'models/file_sharing_page_state.dart';
import 'widgets/card_with_icon_and_text.dart';
import 'widgets/filesharing_headline.dart';

class FileSharingViewHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FileSharingPageBloc>(context);
    return StreamBuilder<List<FileSharingData>>(
      stream: bloc.courseFolders,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        if (snapshot.data!.isEmpty) return _NoCourseFolderFound();

        final fileSharingDataList = snapshot.data!;
        fileSharingDataList
            .sort((a, b) => a.courseName!.compareTo(b.courseName!));

        return SingleChildScrollView(
          padding: const EdgeInsets.only(left: 8, top: 8),
          child: SafeArea(
            child: ColorFadeIn(
              color: Colors.transparent,
              duration: const Duration(milliseconds: 300),
              child: Column(
                key: ValueKey(snapshot),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const FileSharingHeadline(title: "Kursordner"),
                  WrappableList(
                    minWidth: 150,
                    maxElementsPerSection: 3,
                    children: <Widget>[
                      for (final fileSharingData in fileSharingDataList)
                        _CourseFolderCard(fileSharingData)
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CourseFolderCard extends StatelessWidget {
  const _CourseFolderCard(
    this.fileSharingData, {
    Key? key,
  }) : super(key: key);

  final FileSharingData fileSharingData;

  @override
  Widget build(BuildContext context) {
    return CardWithIconAndText(
      onTap: () {
        final stateBloc = BlocProvider.of<FileSharingPageStateBloc>(context);
        final newState = FileSharingPageStateGroup(
          groupID: fileSharingData.courseID,
          path: FolderPath.root,
          initialFileSharingData: fileSharingData,
        );
        stateBloc.changeStateTo(newState);
      },
      text: fileSharingData.courseName,
      icon: Icon(Icons.folder, color: Colors.grey[600]),
    );
  }
}

class _NoCourseFolderFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceholderWidgetWithAnimation(
      svgPath: "assets/icons/folder.svg",
      animateSVG: true,
      title: "Keine Ordner gefunden! 😬",
      description: const Text(
          "Es wurden keine Ordner gefunden, da du noch keinen Kursen beigetreten bist. Trete einfach einem Kurs bei oder erstelle einen eigenen Kurs."),
    );
  }
}
