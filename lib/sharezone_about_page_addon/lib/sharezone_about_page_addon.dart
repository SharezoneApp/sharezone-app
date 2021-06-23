library sharezone_about_page_addon;

import 'dart:ui' as ui;

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_about_page_addon/game/game.dart';

void startTrexGame(BuildContext context, List<ui.Image> sprites) {
  Flame.audio.disableLog();
  final TRexGame game = TRexGame(spriteImage: sprites[0]);
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return TrexPage(
      game: game,
    );
  }));
}

class TrexPage extends StatelessWidget {
  const TrexPage({Key key, this.game}) : super(key: key);
  final TRexGame game;
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
            child: TRexGameWrapper(
              game: game,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: ValueListenableBuilder<double>(
                valueListenable: game.timePlaying,
                builder: (context, value, _) {
                  final timePlayString = value.toStringAsFixed(1);
                  return Text(
                    "Du rettest Sharezone für $timePlayString Sekunden! Danke :)",
                    style: const TextStyle(
                      color: Colors.white,
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
  const TRexGameWrapper({Key key, this.game}) : super(key: key);
  final TRexGame game;

  @override
  _TRexGameWrapperState createState() => _TRexGameWrapperState();
}

class _TRexGameWrapperState extends State<TRexGameWrapper> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.game.widget;
  }
}
