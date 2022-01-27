// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/navigation/analytics/events/drawer_event.dart';
import 'package:sharezone/navigation/analytics/events/nav_bottom_bar_event.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';

import 'events/navigation_event.dart';

class NavigationAnalytics extends BlocBase {
  final Analytics _analytics;

  NavigationAnalytics(this._analytics);

  void logBottomNavigationBarEvent(NavigationItem item) {
    _analytics.log(NavBottomBar(item.getAnalyticsName()));
  }

  void logDrawerEvent(NavigationItem item) {
    _analytics.log(DrawerEvent(item.getAnalyticsName()));
  }

  void logUsedSwipeUpLine() {
    _analytics.log(NavigationEvent("used_swipe_up_line"));
  }

  /// Korrekt wäre es gewesen, wenn für dieses Event auch ein
  /// [DrawerEvent] verwendet worden wäre. Jedoch wurde das Event
  /// "drawer_logo_click" schon vor einiger Zeit eingeführt. Würde
  /// man ein [DrawerEvent] verwenden, würde man den Names des
  /// Events ändern und damit viele Daten verlieren (nicht abwärts
  /// kompatibel). Aus diesem Grund wurde ein normales [AnalyticsEvent]
  /// verwendet.
  void logDrawerLogoClick() {
    _analytics.log(AnalyticsEvent("drawer_logo_click"));
  }

  void logOpenDrawer() {
    _analytics.log(AnalyticsEvent("open_drawer"));
  }

  @override
  void dispose() {}
}
