// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

/// Animation starts with [color] and fades with an [duration]
/// to the [child].
class ColorFadeIn extends StatefulWidget {
  const ColorFadeIn({
    Key key,
    this.color = Colors.white,
    this.duration = const Duration(milliseconds: 500),
    this.child,
  }) : super(key: key);

  final Color color;
  final Duration duration;
  final Widget child;

  @override
  _ColorFadeInState createState() => _ColorFadeInState();
}

class _ColorFadeInState extends State<ColorFadeIn> {
  double opacity = 0;

  @override
  void initState() {
    startFadeInAnimation();
    super.initState();
  }

  Future<void> startFadeInAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      setState(() {
        opacity = 1;
      });
    } catch (e) {
      // Warum wir dein Try-Catch verwendet? Liefert der
      // onAuthChanged Stream von FirebaseAuth keinen Wert, wird
      // die OnboardingPage aufgerufen, weswegen auch dieses Widget
      // aufgerufen wird. Nach einen kleinen Augenblick hat der
      // onAuthChanged Stream aber dann die Daten und merkt, dass der
      // Nutzer evtl. angemeldet ist. Also öffnet dieser dann normal die
      // Onboarding-Page. Kurs danach möchte aber das ColorFadeIn Widget
      // ausfaden, was aber nicht mehr geht, weil es das Widget nicht gibt
      // (die Dashboard-Page wurde ja aufgerufen).
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}
