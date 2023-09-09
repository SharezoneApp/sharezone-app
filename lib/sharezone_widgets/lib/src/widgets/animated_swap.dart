// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

/// A widget to perform a scale and fade transaction at once using
/// [AnimatedSwitcher].
class AnimatedSwap extends StatelessWidget {
  const AnimatedSwap({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 250),
  });

  /// The current [child] widget to display.
  ///
  /// The child is considered to be "new" if it has a different type or [Key]
  /// (see [Widget.canUpdate]).
  final Widget child;

  /// The [duration] property determines the length of time it takes for the
  /// widget to transition from displaying the old [child] to displaying the new
  /// [child].
  ///
  /// When a new [child] is set, the duration property is applied to the new
  /// [child]. The same [duration] is used when fading out the old [child],
  /// unless the reverseDuration property is set. Note that changing the
  /// duration property will not affect the durations of transitions that are
  /// already in progress.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeInQuart,
      switchOutCurve: Curves.easeOutQuart,
      transitionBuilder: (widget, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: widget,
          ),
        );
      },
      child: child,
    );
  }
}
