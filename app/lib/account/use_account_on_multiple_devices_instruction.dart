// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/groups/src/widgets/contact_support.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

class UseAccountOnMultipleDevicesInstructions extends StatelessWidget {
  static const tag = "use-account-on-multiple-devices-instruction-page";

  const UseAccountOnMultipleDevicesInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.useAccountInstructionsAppBarTitle),
        centerTitle: true,
      ),
      body: DefaultTextStyle(
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).isDarkTheme ? Colors.white : Colors.black,
          fontFamily: rubik,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: SafeArea(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Title(),
                const SizedBox(height: 12),
                if (MediaQuery.of(context).orientation ==
                    Orientation.portrait) ...[
                  _ExplainingVideo(),
                  const SizedBox(height: 12),
                  _Steps(),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _Steps(),
                      const SizedBox(width: 24),
                      _ExplainingVideo(),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const ContactSupport(),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.useAccountInstructionsHeadline,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

class _Steps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          context.l10n.useAccountInstructionsStepsTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(context.l10n.useAccountInstructionsStep),
      ],
    );
  }
}

class _ExplainingVideo extends StatefulWidget {
  @override
  __ExplainingVideoState createState() => __ExplainingVideoState();
}

class __ExplainingVideoState extends State<_ExplainingVideo> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://sharezone.net/sign_in_sign_out'),
    );

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          context.l10n.useAccountInstructionsVideoTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 400,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              );
            }
            return const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: AccentColorCircularProgressIndicator()),
            );
          },
        ),
      ],
    );
  }
}
