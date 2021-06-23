import 'package:flutter/material.dart';

/// Animiert eine Seite, die mit dem Navigator gepusht wird. Die
/// Animation skaliert die Page von klein nach groß.
///
/// Beispiel zur Nutzung:
/// Navigator.push(
///   context,
///   ScaleUpRoute(child: Widget(), tag: "widget-page"),
/// )
class ScaleUpRoute<T> extends MaterialPageRoute<T> {
  final double begin;

  ScaleUpRoute(
      {@required Widget child, @required this.begin, @required String tag})
      : super(builder: (context) => child, settings: RouteSettings(name: tag));

  @override
  Duration get transitionDuration => Duration(milliseconds: 250); 

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final tween = Tween<double>(begin: begin, end: 1)
        .chain(CurveTween(curve: Curves.easeInOut));
    final scaleAnimation = animation.drive(tween);
    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}
