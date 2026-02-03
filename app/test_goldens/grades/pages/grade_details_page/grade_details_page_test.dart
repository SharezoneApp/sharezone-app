// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/models/grade_id.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page_controller.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page_controller_factory.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_view.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

import '../../../flutter_test_config.dart';
import 'grade_details_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GradeDetailsPageController>(),
  MockSpec<GradeDetailsPageControllerFactory>(),
])
void main() {
  group(GradeDetailsPage, () {
    const id = GradeId('1');
    late MockGradeDetailsPageControllerFactory controllerFactory;
    late MockGradeDetailsPageController controller;

    setUp(() {
      controllerFactory = MockGradeDetailsPageControllerFactory();
      controller = MockGradeDetailsPageController();
      when(controllerFactory.create(id)).thenReturn(controller);
    });

    void setState(GradeDetailsPageState state) {
      // Mockito does not support mocking sealed classes yet, so we have to
      // provide a dummy implementation of the state.
      //
      // Ticket: https://github.com/dart-lang/mockito/issues/675
      provideDummy<GradeDetailsPageState>(state);
      when(controller.state).thenReturn(state);
    }

    void setLoaded() {
      const dummyView = GradeDetailsView(
        gradeValue: '5',
        gradingSystem: '5-Point',
        subjectDisplayName: 'Math',
        date: '2021-09-01',
        gradeType: 'Test',
        termDisplayName: '1st Term',
        integrateGradeIntoSubjectGrade: true,
        title: 'Algebra',
        details: 'This is a test grade for algebra.',
      );
      setState(const GradeDetailsPageLoaded(dummyView));
    }

    void setError() {
      setState(const GradeDetailsPageError('An error occurred.'));
    }

    void setLoading() {
      setState(const GradeDetailsPageLoading());
    }

    Future<void> pushGradeDetailsPage(
      WidgetTester tester,
      ThemeData theme,
    ) async {
      await tester.pumpWidgetBuilder(
        Provider<GradeDetailsPageControllerFactory>.value(
          value: controllerFactory,
          child: ChangeNotifierProvider<GradeDetailsPageController>.value(
            value: controller,
            child: const GradeDetailsPage(id: id),
          ),
        ),
        wrapper: materialAppWrapper(
          theme: theme,
          localizations: SharezoneLocalizations.localizationsDelegates,
          localeOverrides: defaultLocales,
        ),
      );
    }

    group('with data', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setLoaded();
        await pushGradeDetailsPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'grade_details_page_with_data_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setLoaded();
        await pushGradeDetailsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'grade_details_page_with_data_dark');
      });
    });

    group('error', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setError();
        await pushGradeDetailsPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'grade_details_page_error_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setError();
        await pushGradeDetailsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'grade_details_page_error_dark');
      });
    });

    group('loading', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setLoading();
        await pushGradeDetailsPage(tester, getLightTheme());
        await multiScreenGolden(
          tester,
          'grade_details_page_loading_light',
          customPump:
              (tester) => tester.pump(const Duration(milliseconds: 100)),
        );
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setLoading();
        await pushGradeDetailsPage(tester, getDarkTheme());
        await multiScreenGolden(
          tester,
          'grade_details_page_loading_dark',
          customPump:
              (tester) => tester.pump(const Duration(milliseconds: 100)),
        );
      });
    });
  });
}
