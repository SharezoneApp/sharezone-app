import 'package:analytics/analytics.dart';
import 'package:authentification_base/authentification_analytics.dart';
import 'package:test/test.dart';

import '../analytics_test.dart';

void main() {
  group('register analytics', () {
    LocalAnalyticsBackend backend;
    Analytics analytics;

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
