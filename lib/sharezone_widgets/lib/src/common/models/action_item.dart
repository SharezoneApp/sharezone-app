// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

class ActionItem {
  final String tooltip, title;
  final IconData iconData;
  final Color textColor;
  final Color color;
  final VoidCallback onSelect;

  ActionItem({
    this.tooltip,
    @required this.title,
    this.iconData,
    this.textColor,
    this.color,
    @required this.onSelect,
  });
}
