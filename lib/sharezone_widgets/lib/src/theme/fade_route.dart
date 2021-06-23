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
