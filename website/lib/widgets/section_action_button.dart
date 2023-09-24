// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

import '../extensions/hover_extensions.dart';
import '../utils.dart';
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
      onTap: () => launchUrl(link!),
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
        color: color ?? Theme.of(context).primaryColor,
        child: Text("—> $text"),
      ).moveLeftOnHover,
    );
  }
}
