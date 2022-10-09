import 'package:flutter/material.dart';
import "package:build_context/build_context.dart";

import '../utils.dart';
import '../extensions/hover_extensions.dart';
import 'transparent_button.dart';

class SectionActionButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  final Color? color;
  final double? fontSize;

  const SectionActionButton({
    super.key,
    this.text,
    this.onTap,
    this.color,
    this.fontSize,
  });

  factory SectionActionButton.openLink(
      {String? link, String? text, Color? color, double? fontSize}) {
    return SectionActionButton(
      text: text,
      onTap: () => launchURL(link!),
      color: color,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Disable selection to prevent showing a selection mouse pointer.
    return SelectionContainer.disabled(
      child: TransparentButton(
        onTap: onTap,
        fontSize: fontSize ?? 22,
        color: color ?? context.primaryColor,
        child: Text("—> $text"),
      ).moveLeftOnHover,
    );
  }
}
