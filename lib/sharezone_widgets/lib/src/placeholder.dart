// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

/// This is the Model of the EmptyList
/// Hier wird definiert, wie das Widget aufgebaut sein soll
class PlaceholderModel extends StatefulWidget {
  const PlaceholderModel({
    super.key,
    this.title,
    this.subtitle,
    this.svgPath,
    this.iconSize,
    required this.animateSVG,
    this.rivePath,
    this.riveAnimationName,
  });

  final String? title, svgPath, rivePath;
  final Widget? subtitle;
  final Size? iconSize;
  final bool animateSVG;
  final String? riveAnimationName;

  @override
  PlaceholderModelState createState() => PlaceholderModelState();
}

class PlaceholderModelState extends State<PlaceholderModel>
    with TickerProviderStateMixin {
  AnimationController? _controllerIcon;

  @override
  void initState() {
    super.initState();
    _controllerIcon = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    );

    if (widget.animateSVG) _controllerIcon!.repeat();
  }

  @override
  void dispose() {
    _controllerIcon?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 370),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 20,
            child: FadeInAnimation(child: widget),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _RotateAnimation(
                controller: _controllerIcon!,
                size: widget.iconSize,
                path: widget.svgPath,
                rivePath: widget.rivePath,
                riveAnimationName: widget.riveAnimationName,
              ),
            ),
            const SizedBox(height: 7.5),
            if (isNotEmptyOrNull(widget.title))
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  widget.title!,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DefaultTextStyle(
                style: TextStyle(
                    fontFamily: rubik,
                    color: Theme.of(context).isDarkTheme
                        ? Colors.white70
                        : Colors.grey[800]),
                textAlign: TextAlign.center,
                child: widget.subtitle ?? Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderWidgetWithAnimation extends StatelessWidget {
  const PlaceholderWidgetWithAnimation({
    super.key,
    required this.title,
    this.description,
    required this.svgPath,
    this.iconSize = const Size(175, 175),
    this.animateSVG = false,
    this.scrollable = true,
    this.center = true,
  });

  final String title, svgPath;
  final Widget? description;
  final Size iconSize;
  final bool animateSVG, scrollable, center;

  @override
  Widget build(BuildContext context) {
    final w = PlaceholderModel(
      animateSVG: animateSVG,
      svgPath: svgPath,
      title: title,
      subtitle: description,
      iconSize: iconSize,
    );

    if (!center && !scrollable) return w;
    if (!center && scrollable) return SingleChildScrollView(child: w);
    if (center && !scrollable) return Center(child: w);
    return Center(child: SingleChildScrollView(child: w));
  }
}

class _RotateAnimation extends StatelessWidget {
  _RotateAnimation({
    required this.controller,
    this.size,
    this.path,
    this.rivePath,
    this.riveAnimationName,
  })  : rotate = Tween<double>(
          begin: 0,
          end: 1, // Do 1 Roation
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.2, // Starts at 20% of the Animation
              0.3, // Ends at 30% of the Animation
              curve: Curves.ease, // Easy Ease Out
            ),
          ),
        );

  final Animation<double> controller;
  final Animation<double> rotate;

  final Size? size;
  final String? path;
  final String? rivePath;
  final String? riveAnimationName;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Container(
          alignment: Alignment.center,
          child: RotationTransition(
            turns: AlwaysStoppedAnimation(rotate.value),
            child: isNotEmptyOrNull(rivePath)
                ? _Rive(
                    size: size,
                    path: rivePath,
                    animationName: riveAnimationName,
                  )
                : SVGIcon(
                    path: path,
                    size: size,
                  ),
          ),
        );
      },
    );
  }
}

class _Rive extends StatelessWidget {
  const _Rive({
    required this.size,
    required this.path,
    required this.animationName,
  });

  final Size? size;
  final String? path;
  final String? animationName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size!.height,
      width: size!.width,
      child: FlareActor(
        path,
        animation: animationName,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}

/// Ghost SVG
class SVGIcon extends StatefulWidget {
  const SVGIcon({
    super.key,
    this.size,
    required this.path,
  });

  final Size? size;
  final String? path;

  @override
  SVGIconState createState() => SVGIconState();
}

class SVGIconState extends State<SVGIcon> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size!.width,
      height: widget.size!.height,
      child: PlatformSvg.asset(widget.path!),
    );
  }
}
