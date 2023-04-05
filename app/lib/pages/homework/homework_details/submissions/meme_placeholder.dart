// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:video_player/video_player.dart';

class MemePlaceholder extends StatefulWidget {
  final String url;
  final String text;

  const MemePlaceholder({Key key, @required this.url, this.text})
      : super(key: key);

  @override
  _MemePlaceholderState createState() => _MemePlaceholderState();
}

class _MemePlaceholderState extends State<MemePlaceholder> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final videoPlayer = AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
    return Padding(
      padding: EdgeInsets.only(
          left: 24, right: 24, top: MediaQuery.of(context).size.height * 0.175),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _controller.value.isInitialized
                    ? Center(
                        key: const ValueKey('loaded'),
                        // Wegen einem Bug von Flutter funktioniert ClipRRect + VideoPlayer mit
                        // dem Skia-Render nicht (Web-App crasht). Deswegen muss im Web der
                        // VideoPlayer ohne ClipRRect aufgerufen werden.
                        // Ticket: https://github.com/flutter/flutter/issues/56785
                        child: PlatformCheck.isWeb
                            ? videoPlayer
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: videoPlayer,
                              ),
                      )
                    : Center(
                        key: const ValueKey('loading'),
                        child: AccentColorCircularProgressIndicator(),
                      ),
              ),
            ),
            if (widget.text != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
