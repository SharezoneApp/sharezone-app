// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// A video player that used for small tutorials or demo videos.
class TutorialVideoPlayer extends StatefulWidget {
  const TutorialVideoPlayer({
    super.key,
    required this.aspectRatio,
    required this.videoUrl,
  });

  final double aspectRatio;
  final String videoUrl;

  @override
  State<TutorialVideoPlayer> createState() => _TutorialVideoPlayerState();
}

class _TutorialVideoPlayerState extends State<TutorialVideoPlayer> {
  late final VideoPlayerController _controller;
  ChewieController? _chewieController;
  String? error;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _controller.addListener(_handleError);
    initVideo();
  }

  void _handleError() {
    if (_controller.value.hasError) {
      setState(() {
        error = _controller.value.errorDescription;
      });
    }
  }

  Future<void> initVideo() async {
    try {
      await _controller.initialize();

      // Required for auto play on web
      await _controller.setVolume(0);

      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoInitialize: true,
          autoPlay: true,
          looping: true,
          showControlsOnInitialize: false,
          showControls: false,
        );
      });
    } catch (e) {
      log('Could not load video: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  _chewieController == null
                      ? const SizedBox.shrink()
                      : Chewie(controller: _chewieController!),
            ),
            if (error != null) _ErrorText(error: error!),
          ],
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Text(error, style: const TextStyle(color: Colors.red, fontSize: 20));
  }
}
