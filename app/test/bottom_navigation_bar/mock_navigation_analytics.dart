// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/navigation/analytics/navigation_analytics.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';

class MockNavigationAnalytics implements NavigationAnalytics {
  Map<NavigationItem, bool> bottomNavigationBarLogged = {};
  Map<NavigationItem, bool> drawerEventLogged = {};
  bool drawerLogoLogged = false;
  bool openDrawerLogged = false;
  bool swipeUpLineLogged = false;

  @override
  void dispose() {}

  @override
  void logBottomNavigationBarEvent(NavigationItem item) {
    bottomNavigationBarLogged[item] = true;
  }

  @override
  void logDrawerEvent(NavigationItem item) {
    drawerEventLogged[item] = true;
  }

  @override
  void logDrawerLogoClick() {
    drawerLogoLogged = true;
  }

  @override
  void logOpenDrawer() {
    openDrawerLogged = true;
  }

  @override
  void logUsedSwipeUpLine() {
    swipeUpLineLogged = true;
  }
}
