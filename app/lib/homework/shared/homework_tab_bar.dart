// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class HomeworkTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Tab> tabs;

  const HomeworkTabBar({super.key, required this.tabs});

  TabBar getTabBar([BuildContext? context]) {
    Color indicatorColor;
    if (context != null) {
      indicatorColor =
          Theme.of(context).isDarkTheme ? primaryColor : darkBlueColor;
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
