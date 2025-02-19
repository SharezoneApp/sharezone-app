import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_analytics.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_page_controller.dart';
import 'package:analytics/analytics.dart';

import '../../../../test_goldens/grades/pages/create_term_page/create_term_page_test.mocks.dart';
import '../../../analytics/analytics_test.dart';

void main() {
  group('$CreateTermPageController', () {
    test(
      'throws $InvalidTermNameException when saving a term without a name',
      () {
        final controller = CreateTermPageController(
          gradesService: GradesService(),
          analytics: CreateTermAnalytics(Analytics(LocalAnalyticsBackend())),
          crashAnalytics: MockCrashAnalytics(),
        );

        expect(
          () async => await controller.save(),
          throwsA(isA<InvalidTermNameException>()),
        );
      },
    );
  });
}
