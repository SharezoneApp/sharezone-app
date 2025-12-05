// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:clock/clock.dart';
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
import '../../../../test/homework/homework_dialog_test.dart';
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
        coursesStream: Stream.value([
          courseWith(id: 'deutsch', name: 'Deutsch'),
        ]),
        crashAnalytics: crashAnalytics,
        analytics: analytics,
        gradeId: gradeId,
      );
    }

    setUp(() {
      withClock(Clock.fixed(DateTime(2025, 03, 25)), () async {
        gradesService = GradesService();
        gradesTestController = GradesTestController(
          gradesService: gradesService,
        );
        crashAnalytics = MockCrashAnalytics();
        analytics = MockAnalytics();
        controller = createController();
        controllerFactory = MockGradesDialogControllerFactory();

        when(controllerFactory.create(any)).thenAnswer((_) => controller);
      });
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
      void setup() {
        gradesTestController.createTerm(
          termWith(
            id: const TermId('term-125'),
            name: '1/25',
            gradingSystem: GradingSystem.zeroToFifteenPoints,
            subjects: [
              subjectWith(
                id: const SubjectId('deutsch'),
                name: 'Deutsch',
                grades: [gradeWith()],
              ),
            ],
          ),
        );
      }

      Future<void> setData(WidgetTester tester) async {
        controller.setTerm(const TermId('term-125'));
        // Idk why this doesn't work :(
        // I don't know how to fix it right now
        // controller.setSubject(SubjectId('deutsch'));
        controller.setTitle('Analyse Schiller');
        controller.setGradingSystem(GradingSystem.oneToSixWithDecimals);
        controller.setGrade('2.25');
        controller.setDate(Date("2025-02-22"));
        controller.setDetails('Analyse von Schillers Buch "Die Räuber"');
        controller.setGradeType(GradeType.presentation);
        controller.setIntegrateGradeIntoSubjectGrade(true);

        await tester.pumpAndSettle();
      }

      testGoldens('renders as expected (light mode)', (tester) async {
        setup();
        await pushGradeDetailsPage(tester, getLightTheme());
        await setData(tester);
        await multiScreenGolden(tester, 'grade_dialog_create_filled_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setup();
        await pushGradeDetailsPage(tester, getDarkTheme());
        await setData(tester);
        await multiScreenGolden(tester, 'grade_dialog_create_filled_dark');
      });
    });

    group('editing existing grade', () {
      void createExistingGrade() {
        gradesTestController.createTerm(
          termWith(
            id: const TermId('term-225'),
            name: '2/25',
            gradingSystem: GradingSystem.zeroToFifteenPoints,
            subjects: [
              subjectWith(
                id: const SubjectId('maths'),
                name: 'Mathe',
                grades: [
                  gradeWith(
                    id: const GradeId('grade1'),
                    title: 'Graphen analysieren',
                    gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
                    includeInGradeCalculations: false,
                    type: GradeType.writtenExam.id,
                    value: '2-',
                    date: Date("2025-02-25"),
                    details: 'Analyse von Graphen',
                  ),
                ],
              ),
            ],
          ),
        );
      }

      testGoldens('renders as expected (light mode)', (tester) async {
        createExistingGrade();
        controller = createController(gradeId: const GradeId('grade1'));
        await pushGradeDetailsPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'grade_dialog_edit_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        createExistingGrade();
        controller = createController(gradeId: const GradeId('grade1'));
        await pushGradeDetailsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'grade_dialog_edit_dark');
      });
    });
  });
}
