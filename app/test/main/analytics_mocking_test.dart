// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:analytics/null_analytics_backend.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Analytics refactoring', () {
    test('Analytics can be instantiated with NullAnalyticsBackend for tests',
        () {
      // This test demonstrates that we can now create Analytics instances
      // with a NullAnalyticsBackend for testing purposes.
      //
      // Before the refactoring, code was directly calling Analytics(getBackend())
      // which would call FirebaseAnalytics.instance, making it impossible to mock.

      final mockAnalytics = Analytics(NullAnalyticsBackend());

      // The analytics instance should not be null
      expect(mockAnalytics, isNotNull);

      // We can call analytics methods without errors
      mockAnalytics.log(AnalyticsEvent('test_event'));
      mockAnalytics.setAnalyticsCollectionEnabled(false);

      // This demonstrates that we can now pass this mocked analytics instance
      // to any class or widget that accepts Analytics as a parameter.
    });

    test('NullAnalyticsBackend does not throw errors', () {
      final backend = NullAnalyticsBackend();

      // All methods should execute without errors
      expect(() => backend.log('test', {}), returnsNormally);
      expect(
        () => backend.setAnalyticsCollectionEnabled(false),
        returnsNormally,
      );
      expect(() => backend.logSignUp(signUpMethod: 'test'), returnsNormally);
      expect(
        () => backend.setCurrentScreen(screenName: 'test'),
        returnsNormally,
      );
      expect(
        () => backend.setUserProperty(name: 'test', value: 'test'),
        returnsNormally,
      );
    });
  });
}
