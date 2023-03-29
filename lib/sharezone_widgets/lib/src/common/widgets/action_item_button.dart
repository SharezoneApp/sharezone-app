// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

import '../models/action_item.dart';

class ActionItemButton extends StatelessWidget {
  final ActionItem item;

  const ActionItemButton({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.iconData != null) {
      return TextButton.icon(
        icon: Icon(item.iconData, color: item.textColor),
        onPressed: item.onSelect,
        style: TextButton.styleFrom(
          foregroundColor: item.textColor ?? Theme.of(context).primaryColor,
          backgroundColor: item.color,
        ),
        label: Text(item.title.toUpperCase()),
      );
    } else {
      return TextButton(
        onPressed: item.onSelect,
        style: TextButton.styleFrom(
          foregroundColor: item.textColor ?? Theme.of(context).primaryColor,
          backgroundColor: item.color,
        ),
        child: Text(item.title.toUpperCase()),
      );
    }
  }
}
