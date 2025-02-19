// Copyright (c) 2025 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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
      final term = gradesService.terms.value.single;
      expect(term.name, 'Test');
      expect(term.isActiveTerm, true);
      expect(term.finalGradeType.id, GradeType.schoolReportGrade.id);
      expect(term.gradingSystem, GradingSystem.oneToSixWithPlusAndMinus);
      expect(
        term.gradeTypeWeightings,
        IMap({
          GradeType.writtenExam.id: const Weight.percent(50),
          GradeType.oralParticipation.id: const Weight.percent(50),
        }),
      );
    });

    test('saves term with custom grading system', () async {
      controller.setName('foo');
      controller.setGradingSystem(GradingSystem.zeroToFifteenPoints);

      await controller.save();

      final term = gradesService.terms.value.single;
      expect(term.gradingSystem, GradingSystem.zeroToFifteenPoints);
    });

    test('saves term that is not active', () async {
      controller.setName('Inactive Term');
      controller.setIsCurrentTerm(false);

      await controller.save();

      final term = gradesService.terms.value.single;
      expect(term.isActiveTerm, false);
    });
  });
}
