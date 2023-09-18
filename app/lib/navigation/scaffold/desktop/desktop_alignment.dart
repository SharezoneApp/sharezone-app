// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

const double _drawerWidth = 270;

class DesktopAlignment extends StatelessWidget {
  final Widget drawer;
  final Widget scaffold;

  const DesktopAlignment({
    Key? key,
    required this.drawer,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: <Widget>[
          SizedBox(width: _drawerWidth, child: drawer),
          Container(
              width: 1,
              color: isDarkThemeEnabled(context)
                  ? Colors.grey.withOpacity(0.1)
                  : Colors.grey[200]),
          Expanded(child: scaffold),
        ],
      ),
    );
  }
}
