// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller_factory.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../../../../test/grades/grades_test_common.dart';
import '../../../../test/grades/pages/grades_dialog/grades_dialog_controller_test.dart';

import 'grades_dialog_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GradesDialogControllerFactory>()])
void main() {
  group(GradeDetailsPage, () {
    late GradesTestController gradesTestController;
    late GradesService gradesService;
    late CrashAnalytics crashAnalytics;
    late Analytics analytics;
    late GradesDialogController controller;
    late MockGradesDialogControllerFactory controllerFactory;

    GradesDialogController createController({GradeId? gradeId}) {
      return GradesDialogController(
        gradesService: gradesService,
        coursesStream: Stream.value([]),
        crashAnalytics: crashAnalytics,
        analytics: analytics,
        gradeId: gradeId,
      );
    }

    setUp(() {
      gradesService = GradesService();
      gradesTestController = GradesTestController(gradesService: gradesService);
      crashAnalytics = MockCrashAnalytics();
      analytics = MockAnalytics();
      controller = createController();
      controllerFactory = MockGradesDialogControllerFactory();

      when(controllerFactory.create(any)).thenAnswer((_) => controller);
    });

    Future<void> pushGradeDetailsPage(
      WidgetTester tester,
      ThemeData theme, {
      GradeId? gradeId,
    }) async {
      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            Provider<GradesDialogControllerFactory>.value(
              value: controllerFactory,
            ),
          ],
          child: GradesDialog(gradeId: gradeId),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    group('creating new grade (empty)', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        await pushGradeDetailsPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'grade_dialog_create_empty_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        await pushGradeDetailsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'grade_dialog_create_empty_dark');
      });
    });

    group('creating new grade (filled fields)', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        await pushGradeDetailsPage(tester, getLightTheme());

        controller.setTitle('Analysis of Schiller');
        controller.setGradingSystem(GradingSystem.oneToSixWithDecimals);
        controller.setGrade('2.25');
        controller.setDate(Date("2025-02-22"));
        controller.setDetails('Analysis of Schillers Book "Die Räuber"');
        controller.setGradeType(GradeType.presentation);
        controller.setIntegrateGradeIntoSubjectGrade(true);

        await multiScreenGolden(tester, 'grade_dialog_create_filled_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        await pushGradeDetailsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'grade_dialog_create_filled_dark');
      });
    });

    group('editing existing grade', () {
      void createExistingGrade() {
        gradesTestController.createTerm(
          termWith(
            id: TermId('foo'),
            name: 'Foo term',
            gradingSystem: GradingSystem.zeroToFifteenPoints,
            subjects: [
              subjectWith(
                id: SubjectId('maths'),
                name: 'Maths',
                grades: [
                  gradeWith(
                    id: GradeId('grade1'),
                    title: 'Foo',
                    gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
                    includeInGradeCalculations: false,
                    type: GradeType.presentation.id,
                    value: '2-',
                    date: Date("2025-02-21"),
                    details: 'Notes',
                  ),
                ],
              ),
            ],
          ),
        );
      }

      testGoldens('renders as expected (light mode)', (tester) async {
        createExistingGrade();
        controller = createController(gradeId: GradeId('grade1'));
        await pushGradeDetailsPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'grade_dialog_edit_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        createExistingGrade();
        controller = createController(gradeId: GradeId('grade1'));
        await pushGradeDetailsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'grade_dialog_edit_dark');
      });
    });
  });
}
