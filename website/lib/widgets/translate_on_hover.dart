// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class MoveLeftOnHover extends StatefulWidget {
  final Widget? child;
  // You can also pass the translation in here if you want to
  const MoveLeftOnHover({super.key, this.child});

  @override
  MoveLeftOnHoverState createState() => MoveLeftOnHoverState();
}

class MoveLeftOnHoverState extends State<MoveLeftOnHover> {
  // Please use 0.0 instead of 0. You will get a .toDouble() issue, if you
  // use 0 instead of 0.0
  final nonHoverTransform =
      Matrix4.identity()..translateByDouble(0.0, 0, 0.0, 1.0);
  final hoverTransform =
      Matrix4.identity()..translateByDouble(10.0, 0.0, 0.0, 1.0);

  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => _mouseEnter(true),
      onExit: (e) => _mouseEnter(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _hovering ? hoverTransform : nonHoverTransform,
        child: widget.child,
      ),
    );
  }

  void _mouseEnter(bool hover) {
    setState(() {
      _hovering = hover;
    });
  }
}
