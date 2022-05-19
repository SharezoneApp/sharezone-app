import 'package:flutter/material.dart';

import '../utils.dart';

class TransparentButton extends StatelessWidget {
  const TransparentButton({
    super.key,
    this.onTap,
    this.child,
    this.fontSize = 18,
    this.color,
  });

  final VoidCallback? onTap;
  final double fontSize;
  final Color? color;
  final Widget? child;

  factory TransparentButton.openLink({
    String? link,
    Widget? child,
    double fontSize = 18,
    Color? color,
  }) {
    return TransparentButton(
      fontSize: fontSize,
      color: color,
      child: child,
      onTap: () => launchURL(link!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: fontSize,
          color: color ?? Colors.black,
        ),
        child: child!,
      ),
    );
  }
}
