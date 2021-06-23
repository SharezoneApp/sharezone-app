import 'package:flutter/material.dart';

class MaxWidthConstraintBox extends StatelessWidget {
  const MaxWidthConstraintBox(
      {Key key, @required this.child, this.maxWidth = 1000})
      : super(key: key);

  final Widget child;

  /// Default value is 1000.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}