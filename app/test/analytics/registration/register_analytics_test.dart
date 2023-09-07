// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:authentification_base/authentification_analytics.dart';
import 'package:flutter_test/flutter_test.dart';

import '../analytics_test.dart';

void main() {
  group('register analytics', () {
    late LocalAnalyticsBackend backend;
    late Analytics analytics;

    setUp(() {
      backend = LocalAnalyticsBackend();
      analytics = Analytics(backend);
    });

    test('A register analytics logs a anonymous register in boarding', () {
      final event = AuthentifactionEvent(
          name: "registered", provider: "anonymousInOnboarding");

      analytics.log(event);

      expect(backend.getSingleEventData("registered"),
          {"registeredWith": "anonymousInOnboarding"});
    });
  });
}
