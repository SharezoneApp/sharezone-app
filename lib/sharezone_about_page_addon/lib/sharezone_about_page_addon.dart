// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

library sharezone_about_page_addon;

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharezone_about_page_addon/game/game.dart';

void startTrexGame(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return const TrexPage();
  }));
}

class TrexPage extends StatelessWidget {
  const TrexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rette Sharezone",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: TRexGameWrapper(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: StreamBuilder<void>(
                stream: Stream.periodic(const Duration(milliseconds: 50)),
                builder: (context, _) {
                  final timePlayString =
                      _game?.timePlaying.toStringAsFixed(1) ?? '0';
                  return Text(
                    "Du rettest Sharezone für $timePlayString Sekunden! Danke :)",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TRexGameWrapper extends StatefulWidget {
  @override
  _TRexGameWrapperState createState() => _TRexGameWrapperState();
}

TRexGame? _game;

class _TRexGameWrapperState extends State<TRexGameWrapper> {
  bool splashGone = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    _game = null;
    super.dispose();
  }

  void startGame() {
    Flame.images.loadAll(["sprite.png"]).then(
      (image) => {
        setState(() {
          _game = TRexGame(spriteImage: image[0]);
          _focusNode.requestFocus();
        })
      },
    );
  }

  void onRawKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      _game!.onAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_game == null) {
      return const Center(
        child: Text("Loading"),
      );
    }
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints.expand(),
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: onRawKeyEvent,
        child: GameWidget(
          game: _game!,
        ),
      ),
    );
  }
}
