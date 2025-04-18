// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

/// Zeigt bis zum [transitionPoint] das [startWidget] an
/// und sobald der Nutzer beim swipen der Tabs den [TransaitionPoint] überschreitet,
/// gibt es eine Fade-Animation zwischen [startWidget] & [endWidget]. Danach wird
/// bis [controller.length] das [endWidget] angezeigt.
class FadeSwitchBetweenIndexWithTabController extends StatelessWidget {
  const FadeSwitchBetweenIndexWithTabController({
    super.key,
    this.controller,
    required this.startWidget,
    required this.endWidget,
    required this.transitionPoint,
  });

  /// If a [TabController] is not provided, then there must be a [DefaultTabController]
  /// ancestor.
  final TabController? controller;
  final Widget startWidget;
  final Widget endWidget;
  final BetweenIndex transitionPoint;

  @override
  Widget build(BuildContext context) {
    final controller = this.controller ?? DefaultTabController.of(context);
    final Animation<double> animation = CurvedAnimation(
      parent: controller.animation!,
      curve: Curves.fastOutSlowIn,
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, snapshot) {
        final offset = controller.offset.abs();
        final currentIndex = controller.index;
        if (offset != 0) {
          if (currentIndex == transitionPoint.start &&
              isSwipingRight(controller)) {
            return _FadeBetween(
              value: offset,
              from: startWidget,
              to: endWidget,
            );
          } else if (controller.index == transitionPoint.end &&
              isSwipingLeft(controller)) {
            return _FadeBetween(
              value: offset,
              from: endWidget,
              to: startWidget,
            );
          }
        }
        return controller.index <= transitionPoint.start
            ? startWidget
            : endWidget;
      },
    );
  }

  bool isSwipingLeft(TabController controller) => controller.offset <= 0;
  bool isSwipingRight(TabController controller) => controller.offset >= 0;
}

class _FadeBetween extends StatelessWidget {
  const _FadeBetween({
    required this.value,
    required this.to,
    required this.from,
  });

  final double value;
  final Widget from;
  final Widget to;

  @override
  Widget build(BuildContext context) {
    final value =
        this.value < 0.0
            ? 0.0
            : this.value > 1.0
            ? 1.0
            : this.value;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Opacity(opacity: value, child: to), // endWidget Ausblenden
        Opacity(opacity: 1 - value, child: from), // startWidget Einblenden
      ],
    );
  }
}

class BetweenIndex {
  final int start;
  final int end;

  const BetweenIndex(this.start, this.end)
    : assert(
        end - start == 1,
        "The indexies have to be next to another, while the first Index lies before second Index",
      );
}
