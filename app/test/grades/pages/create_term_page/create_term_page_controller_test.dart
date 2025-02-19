import 'package:analytics/analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_analytics.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_page_controller.dart';

import '../../../../test_goldens/grades/pages/create_term_page/create_term_page_test.mocks.dart';
import '../../../analytics/analytics_test.dart';

void main() {
  late CreateTermPageController controller;
  late GradesService gradesService;

  setUp(() {
    gradesService = GradesService();
    controller = CreateTermPageController(
      gradesService: gradesService,
      analytics: CreateTermAnalytics(Analytics(LocalAnalyticsBackend())),
      crashAnalytics: MockCrashAnalytics(),
    );
  });

  group('$CreateTermPageController', () {
    test(
      'throws $InvalidTermNameException when saving a term without a name',
      () {
        expect(
          () async => await controller.save(),
          throwsA(isA<InvalidTermNameException>()),
        );

        controller.setName('');
        expect(
          () async => await controller.save(),
          throwsA(isA<InvalidTermNameException>()),
        );
      },
    );

    test('saves term successfully with default values', () async {
      controller.setName('Test');
      await controller.save();

      expect(gradesService.terms.value, hasLength(1));
      final term = gradesService.terms.value.first;
      expect(term.name, 'Test');
      expect(term.isActiveTerm, true);
      expect(term.finalGradeType.id, GradeType.schoolReportGrade.id);
      expect(term.gradingSystem, GradingSystem.oneToSixWithPlusAndMinus);
    });

    test('saves term with custom grading system', () async {
      controller.setName('foo');
      controller.setGradingSystem(GradingSystem.zeroToFifteenPoints);
      await controller.save();

      expect(gradesService.terms.value, hasLength(1));
      final term = gradesService.terms.value.first;
      expect(term.gradingSystem, GradingSystem.zeroToFifteenPoints);
    });
  });
}
