// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class FadeRoute<T> extends MaterialPageRoute<T> {
  final Duration duration;

  FadeRoute(
      {@required Widget child, this.duration = const Duration(milliseconds: 250), @required String tag})
      : super(builder: (context) => child, settings: RouteSettings(name: tag));

  @override
  Duration get transitionDuration => duration ?? Duration(milliseconds: 250);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      FadeTransition(opacity: animation, child: child);
}
