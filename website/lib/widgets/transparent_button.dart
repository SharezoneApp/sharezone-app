// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
      onTap: () => launchUrl(link!),
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
