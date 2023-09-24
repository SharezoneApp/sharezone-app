// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class RowSpacing extends StatelessWidget {
  const RowSpacing({
    super.key,
    this.children,
    this.spacing,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final List<Widget>? children;
  final double? spacing;

  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: _buildList(),
    );
  }

  List<Widget> _buildList() {
    final list = <Widget>[];
    for (int i = 0; i < children!.length; i++) {
      list.add(children![i]);
      if (i + 1 != children!.length) {
        list.add(SizedBox(width: spacing));
      }
    }
    return list;
  }
}
