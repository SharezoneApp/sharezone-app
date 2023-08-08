// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

import 'theme/brightness/general_theme.dart';

class RoundedSimpleDialog extends StatelessWidget {
  const RoundedSimpleDialog({
    Key key,
    this.title,
    this.children,
    this.contentPadding = const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
    this.titlePadding = const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
    this.semanticLabel,
  }) : super(key: key);

  final List<Widget> children;
  final EdgeInsetsGeometry contentPadding;

  final EdgeInsetsGeometry titlePadding;
  final Widget title;

  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: contentPadding,
      title: title,
      titlePadding: titlePadding,
      semanticLabel: semanticLabel,
      children: [
        Material(
          borderRadius: BorderRadius.circular(sharezoneBorderRadiusValue),
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).dialogTheme.backgroundColor,
          child: Column(children: children),
        ),
      ],
    );
  }
}
