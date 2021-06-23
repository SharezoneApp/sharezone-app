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
