// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/navigation/analytics/events/drawer_event.dart';
import 'package:sharezone/navigation/analytics/events/nav_bottom_bar_event.dart';

import '../analytics_test.dart';

void main() {
  group('navigation analytics', () {
    late LocalAnalyticsBackend backend;
    late Analytics analytics;

    setUp(() {
      backend = LocalAnalyticsBackend();
      analytics = Analytics(backend);
    });

    test(
        'A navigation analytics logs a drawer tile click with the correct suffix',
        () {
      final event = DrawerEvent("event");

      analytics.log(event);

      expect(backend.getEvent("navigation_drawer_event"), [
        {"navigation_drawer_event": {}}
      ]);
    });

    test(
        'A navigation analytics logs a nav bottom bar click with the correct suffix',
        () {
      final event = NavBottomBar("event");

      analytics.log(event);

      expect(backend.getEvent("navigation_nav_bottom_bar_event"), [
        {"navigation_nav_bottom_bar_event": {}}
      ]);
    });
  });
}
