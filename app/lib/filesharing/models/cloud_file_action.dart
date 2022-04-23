// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';

import 'sheet_option.dart';

class CloudFileAction {
  final SheetOption sheetOption;
  final String name, tooltip;
  final IconData iconData;
  final bool enabled;
  const CloudFileAction({
    this.sheetOption,
    this.name,
    this.tooltip,
    this.iconData,
    this.enabled = true,
  });
}
