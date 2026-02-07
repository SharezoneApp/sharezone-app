// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:design/design.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller_factory.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_view.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../../../flutter_test_config.dart';
import 'term_settings_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TermSettingsPageController>(),
  MockSpec<TermSettingsPageControllerFactory>(),
])
void main() {
  group(TermSettingsPage, () {
    const termId = TermId('term-1');
    late TermSettingsPageController controller;
    late TermSettingsPageControllerFactory controllerFactory;

    setUp(() {
      controller = MockTermSettingsPageController();
      controllerFactory = MockTermSettingsPageControllerFactory();
      when(controllerFactory.create(termId)).thenReturn(controller);
    });

    void setState(TermSettingsState state) {
      // Mockito does not support mocking sealed classes yet, so we have to
      // provide a dummy implementation of the state.
      //
      // Ticket: https://github.com/dart-lang/mockito/issues/675
      provideDummy<TermSettingsState>(state);
      when(controller.state).thenReturn(state);
    }

    void setLoaded1() {
      setState(loadedState1);
    }

    void setLoaded2() {
      setState(loadedState2);
    }

    void setError() {
      setState(const TermSettingsError('An error occurred.'));
    }

    void setLoading() {
      setState(const TermSettingsLoading());
    }

    Future<void> pushTermSettingsPage(
      WidgetTester tester,
      ThemeData theme,
    ) async {
      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            Provider<GradesService>(create: (_) => GradesService()),
            Provider<TermSettingsPageControllerFactory>.value(
              value: controllerFactory,
            ),
            ChangeNotifierProvider<TermSettingsPageController>.value(
              value: controller,
            ),
          ],
          child: const TermSettingsPage(termId: termId),
        ),
        wrapper: materialAppWrapper(
          theme: theme,
          localizations: SharezoneLocalizations.localizationsDelegates,
          localeOverrides: defaultLocales,
        ),
      );
    }

    group('empty', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setLoaded1();
        await pushTermSettingsPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'terms_settings_with_data_1_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setLoaded1();
        await pushTermSettingsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'terms_settings_with_data_1_dark');
      });
    });

    group('with data', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setLoaded2();
        await pushTermSettingsPage(tester, getLightTheme());
        await multiScreenGolden(
          tester,
          'terms_settings_page_with_data_2_light',
        );
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setLoaded2();
        await pushTermSettingsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'terms_settings_page_with_data_2_dark');
      });
    });

    group('error', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setError();
        await pushTermSettingsPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'terms_settings_page_error_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setError();
        await pushTermSettingsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'terms_settings_page_error_dark');
      });
    });

    group('loading', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setLoading();
        await pushTermSettingsPage(tester, getLightTheme());
        await multiScreenGolden(
          tester,
          'terms_settings_page_loading_light',
          customPump:
              (tester) => tester.pump(const Duration(milliseconds: 100)),
        );
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setLoading();
        await pushTermSettingsPage(tester, getDarkTheme());
        await multiScreenGolden(
          tester,
          'terms_settings_page_loading_dark',
          customPump:
              (tester) => tester.pump(const Duration(milliseconds: 100)),
        );
      });
    });
  });
}

final loadedState1 = TermSettingsLoaded(
  TermSettingsPageView(
    name: '10/22',
    isActiveTerm: true,
    gradingSystem: GradingSystem.oneToSixWithPlusAndMinus,
    finalGradeType: GradeType.schoolReportGrade,
    selectableGradingTypes: const IListConst([]),
    weightDisplayType: WeightDisplayType.percent,
    weights: IMapConst({
      GradeType.writtenExam.id: const Weight.percent(200),
      GradeType.oralParticipation.id: const Weight.percent(50),
      GradeType.presentation.id: const Weight.percent(100),
    }),
    subjects: IListConst([
      (
        displayName: 'Deutsch',
        abbreviation: 'DE',
        design: Design.random(Random(42)),
        id: const SubjectId('d'),
        weight: const Weight.factor(1),
      ),
      (
        displayName: 'Englisch',
        abbreviation: 'E',
        design: Design.random(Random(42)),
        id: const SubjectId('e'),
        weight: const Weight.factor(2),
      ),
    ]),
  ),
);

final loadedState2 = TermSettingsLoaded(
  TermSettingsPageView(
    name: '11/23',
    isActiveTerm: true,
    gradingSystem: GradingSystem.zeroToFifteenPoints,
    finalGradeType: GradeType.writtenExam,
    selectableGradingTypes: const IListConst([]),
    weightDisplayType: WeightDisplayType.factor,
    weights: IMapConst({
      GradeType.writtenExam.id: const Weight.factor(2),
      GradeType.oralParticipation.id: const Weight.factor(.5),
      GradeType.presentation.id: const Weight.factor(1),
    }),
    subjects: IListConst([
      (
        displayName: 'Deutsch',
        abbreviation: 'DE',
        design: Design.random(Random(35)),
        id: const SubjectId('d'),
        weight: const Weight.factor(1),
      ),
      (
        displayName: 'Englisch',
        abbreviation: 'E',
        design: Design.random(Random(35)),
        id: const SubjectId('e'),
        weight: const Weight.factor(2),
      ),
    ]),
  ),
);
