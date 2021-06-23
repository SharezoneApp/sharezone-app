import 'package:flutter/material.dart';
import 'package:sharezone_widgets/theme.dart';

const double _drawerWidth = 270;

class DesktopAlignment extends StatelessWidget {
  final Widget drawer;
  final Widget scaffold;

  const DesktopAlignment({Key key, this.drawer, this.scaffold})
      : super(key: key);
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
