// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:files_usecases/src/file_viewer/widgets/video_viewer.dart';
import 'package:flutter/material.dart';
import '../widgets/file_page_app_bar.dart';

class VideoFilePage extends StatelessWidget {
  static const tag = 'video-file-page';

  const VideoFilePage({
    Key key,
    @required this.actions,
    @required this.name,
    @required this.nameStream,
    @required this.downloadURL,
  })  : assert(downloadURL != null),
        super(key: key);

  final String name;
  final Stream<String> nameStream;
  final String downloadURL;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColorBrightness: Brightness.dark),
      child: Scaffold(
        appBar: FilePageAppBar(
          name: name,
          nameStream: nameStream,
          actions: actions,
        ),
        backgroundColor: Colors.black,
        body: VideoViewer(downloadURL: downloadURL),
      ),
    );
  }
}
