// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/theme.dart';

/// Highlights each element from the list after an [alternatingInterval] with
/// [theme.highlightedColor] in the background. It begins with
/// [theme.notHighlightedColor]:
/// Element 1 (Not highlighted)
/// Element 2 (Highlighted)
/// Element 3 (Not highlighted)
/// Element 4 (Highlighted)
class AlternatingColoredList extends StatelessWidget {
  /// Number of total items in this list.
  final int itemCount;

  final IndexedWidgetBuilder itemBuilder;

  /// Intervall of highlighted elements. If number is 2, every second element
  /// will be highlighted. If number is 3, every third element will be
  /// highlighted. Must be > 0
  ///
  /// Example for 3:
  /// Element 1 (Not highlighted)
  /// Element 2 (Not highlighted)
  /// Element 3 (Highlighted)
  /// Element 4 (Not highlighted)
  ///
  /// Default is 2
  final int alternatingInterval;

  final AlternatingColoredListTheme theme;

  const AlternatingColoredList({
    Key key,
    @required this.itemCount,
    @required this.itemBuilder,
    this.alternatingInterval = 2,
    this.theme,
  })  : assert(itemCount != null),
        assert(itemBuilder != null),
        assert(alternatingInterval != null && alternatingInterval > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < itemCount; index++)
          Material(
            // Key is used for testing
            key: ValueKey('AlternatingColoredList;Item:$index'),
            color: _getColor(context, index),
            child: itemBuilder(context, index),
          ),
      ],
    );
  }

  Color _getColor(BuildContext context, int index) {
    if ((index + 1) % alternatingInterval == 0) {
      return theme?.highlightedColor ??
          (isDarkThemeEnabled(context)
              ? const Color(0xFF1a1919)
              : Colors.grey[50]);
    }
    return theme?.notHighlightedColor ?? Colors.transparent;
  }
}

class AlternatingColoredListTheme {
  /// Default is Colors.transparent (Light & Dark Mode)
  final Color highlightedColor;

  /// Default is Color(0xFF1a1919) (Dark Mode) and Colors.grey[50] (Light Mode)
  final Color notHighlightedColor;

  const AlternatingColoredListTheme({
    this.highlightedColor,
    this.notHighlightedColor,
  });
}
