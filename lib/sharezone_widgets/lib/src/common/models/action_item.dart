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
