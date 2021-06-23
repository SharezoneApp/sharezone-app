import 'package:flutter/material.dart';
import 'package:sharezone_widgets/theme.dart';

class HomeworkTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Tab> tabs;

  const HomeworkTabBar({
    Key key,
    @required this.tabs,
  }) : super(key: key);

  TabBar getTabBar([BuildContext context]) {
    Color indicatorColor;
    if (context != null) {
      indicatorColor =
          isDarkThemeEnabled(context) ? primaryColor : darkBlueColor;
    } else {
      // Ist egal, weil es ohne Kontext nur für preferredSize genutzt werden sollte
      indicatorColor = primaryColor;
    }
    return TabBar(indicatorColor: indicatorColor, tabs: tabs);
  }

  @override
  Size get preferredSize => getTabBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return getTabBar(context);
  }
}
