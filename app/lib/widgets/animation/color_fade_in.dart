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
    super.key,
    this.color = Colors.white,
    this.duration = const Duration(milliseconds: 500),
    required this.child,
  });

  final Color color;
  final Duration duration;
  final Widget child;

  @override
  State createState() => _ColorFadeInState();
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

    if (!mounted) return;
    setState(() {
      opacity = 1;
    });
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
