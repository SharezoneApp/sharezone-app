// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  const VideoViewer({Key? key, required this.downloadURL}) : super(key: key);

  final String downloadURL;

  @override
  State createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  ChewieController? _controller;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.downloadURL);
    _videoPlayerController.initialize().then(
      (value) {
        setState(() {
          _controller = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: true,
            aspectRatio: _videoPlayerController.value.aspectRatio,
            looping: true,
          );
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(
        child: AccentColorCircularProgressIndicator(),
      );
    }
    return Chewie(controller: _controller!);
  }
}
