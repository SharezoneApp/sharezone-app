import 'package:flutter/material.dart';

import '../models/action_item.dart';

class ActionItemButton extends StatelessWidget {
  final ActionItem item;

  const ActionItemButton({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.iconData != null)
      return FlatButton.icon(
        icon: Icon(item.iconData, color: item.textColor),
        onPressed: item.onSelect,
        textColor: item.textColor ?? Theme.of(context).primaryColor,
        color: item.color,
        label: Text(item.title.toUpperCase()),
      );
    else
      return FlatButton(
        onPressed: item.onSelect,
        textColor: item.textColor ?? Theme.of(context).primaryColor,
        color: item.color,
        child: Text(item.title.toUpperCase()),
      );
  }
}
