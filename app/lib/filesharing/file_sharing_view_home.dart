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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/filesharing/bloc/file_sharing_page_bloc.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/widgets/animation/color_fade_in.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

// ignore:implementation_imports
import 'logic/file_sharing_page_state_bloc.dart';
import 'models/file_sharing_page_state.dart';
import 'widgets/card_with_icon_and_text.dart';
import 'widgets/filesharing_headline.dart';

class FileSharingViewHome extends StatelessWidget {
  const FileSharingViewHome({super.key});

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
                  const FileStorageUsageIndicator(
                    usedStorage: KiloByteSize(gigabytes: 9),
                    totalStorage: KiloByteSize(gigabytes: 10),
                    plusStorage: KiloByteSize(gigabytes: 30),
                  ),
                  const FileSharingHeadline(title: "Kursordner"),
                  WrappableList(
                    minWidth: 150,
                    maxElementsPerSection: 3,
                    children: <Widget>[
                      for (final fileSharingData in fileSharingDataList)
                        _CourseFolderCard(fileSharingData)
                    ],
                  ),
                  if (kDebugMode) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      child: const Text('Zu wenig Speicherplatz Dialog öffnen'),
                      onPressed: () {
                        showLeftRightAdaptiveDialog(
                          context: context,
                          title: 'Zu wenig Speicherplatz',
                          content: Column(
                            children: [
                              const Text('''
Die Datei (13 MB), die du hochladen wolltest, passt nicht mehr in dein Speicherplatz (10 GB).
                                  
Lösche von dir hochgeladene Dateien, um Speicherplatz freizugeben oder kaufe mehr Speicherplatz mit Sharezone Plus.'''),
                              const SizedBox(height: 16),
                              SharezonePlusFeatureInfoCard(
                                child: Text(
                                    'Mit Sharezone Plus erhältst du 30 GB Speicherplatz.'),
                                withLearnMoreButton: true,
                                onLearnMorePressed: () {
                                  final bloc =
                                      BlocProvider.of<NavigationBloc>(context);
                                  Navigator.pop(context);
                                  bloc.navigateTo(NavigationItem.sharezonePlus);
                                },
                              ),
                            ],
                          ),
                          left: null,
                          right: AdaptiveDialogAction.ok,
                        );
                      },
                    ),
                  ]
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
  const _CourseFolderCard(this.fileSharingData);

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

class FileStorageUsageIndicator extends StatelessWidget {
  const FileStorageUsageIndicator({
    required this.usedStorage,
    required this.totalStorage,
    required this.plusStorage,
    super.key,
  });

  final KiloByteSize usedStorage;
  final KiloByteSize totalStorage;
  final KiloByteSize plusStorage;

  double get _usedStoragePercentage =>
      usedStorage.inBytes / totalStorage.inBytes;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          "Speicherplatz: ${usedStorage.inGigabytes.toStringAsFixed(2)} GB von ${totalStorage.inGigabytes.toInt()} GB belegt"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: _usedStoragePercentage,
            backgroundColor: Colors.grey,
            color: switch (_usedStoragePercentage) {
              < 0.7 => Colors.blueAccent,
              < 0.9 => Colors.orange,
              _ => Colors.red,
            },
            minHeight: 6,
          ),
          if (_usedStoragePercentage >= 0.7) ...[
            const SizedBox(height: 4),
            const Text("Hol dir mehr Speicherplatz mit Sharezone Plus (30 GB)"),
          ]
        ],
      ),
    );
  }
}

class _NoCourseFolderFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const PlaceholderWidgetWithAnimation(
      svgPath: "assets/icons/folder.svg",
      animateSVG: true,
      title: "Keine Ordner gefunden! 😬",
      description: Text(
          "Es wurden keine Ordner gefunden, da du noch keinen Kursen beigetreten bist. Trete einfach einem Kurs bei oder erstelle einen eigenen Kurs."),
    );
  }
}
