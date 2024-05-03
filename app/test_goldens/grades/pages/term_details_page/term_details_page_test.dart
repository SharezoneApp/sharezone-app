// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:date/date.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/models/grade_id.dart';
import 'package:sharezone/grades/models/subject_id.dart';
import 'package:sharezone/grades/models/term_id.dart';
import 'package:sharezone/grades/pages/grades_view.dart';
import 'package:sharezone/grades/pages/term_details_page/term_details_page.dart';
import 'package:sharezone/grades/pages/term_details_page/term_details_page_controller.dart';
import 'package:sharezone/grades/pages/term_details_page/term_details_page_controller_factory.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'term_details_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TermDetailsPageController>(),
  MockSpec<TermDetailsPageControllerFactory>(),
])
void main() {
  group(TermDetailsPage, () {
    const termId = TermId('term-1');
    late MockTermDetailsPageController controller;
    late MockTermDetailsPageControllerFactory controllerFactory;

    setUp(() {
      controller = MockTermDetailsPageController();
      controllerFactory = MockTermDetailsPageControllerFactory();
      when(controllerFactory.create(termId)).thenReturn(controller);
    });

    void setState(TermDetailsPageState state) {
      // Mockito does not support mocking sealed classes yet, so we have to
      // provide a dummy implementation of the state.
      //
      // Ticket: https://github.com/dart-lang/mockito/issues/675
      provideDummy<TermDetailsPageState>(state);
      when(controller.state).thenReturn(state);
    }

    void setEmptyState() {
      setState(const TermDetailsPageLoaded(
        term: (
          id: TermId('term-1'),
          displayName: '10/2',
          avgGrade: ('1,0', GradePerformance.good),
        ),
        subjectsWithGrades: [],
      ));
    }

    void setLoaded() {
      final random = Random(42);
      setState(
        TermDetailsPageLoaded(
          term: (
            id: const TermId('term-1'),
            displayName: '10/2',
            avgGrade: ('1,0', GradePerformance.good),
          ),
          subjectsWithGrades: [
            (
              grades: [
                (
                  id: const GradeId('1'),
                  gradeTypeIcon: const Icon(Icons.note_add),
                  date: Date.fromDateTime(DateTime(2021, 2, 2)).toDateString,
                  grade: '1,0',
                  title: 'Klausur',
                ),
                (
                  id: const GradeId('2'),
                  gradeTypeIcon: const Icon(Icons.text_format),
                  date: Date.fromDateTime(DateTime(2021, 2, 1)).toDateString,
                  grade: '2+',
                  title: 'Vokabeltest',
                ),
              ],
              subject: (
                displayName: 'Deutsch',
                abbreviation: 'DE',
                grade: '2,0',
                design: Design.random(random),
                id: const SubjectId('1'),
              ),
            ),
            (
              grades: [],
              subject: (
                displayName: 'Englisch',
                abbreviation: 'E',
                grade: '2+',
                design: Design.random(random),
                id: const SubjectId('2'),
              ),
            ),
            (
              grades: [],
              subject: (
                displayName: 'Mathe',
                abbreviation: 'DE',
                grade: '1-',
                design: Design.random(random),
                id: const SubjectId('3'),
              ),
            ),
          ],
        ),
      );
    }

    void setError() {
      setState(const TermDetailsPageError('An error occurred.'));
    }

    void setLoading() {
      setState(const TermDetailsPageLoading());
    }

    Future<void> pushTermDetailsPage(
        WidgetTester tester, ThemeData theme) async {
      await tester.pumpWidgetBuilder(
        Provider<TermDetailsPageControllerFactory>.value(
          value: controllerFactory,
          child: ChangeNotifierProvider<TermDetailsPageController>.value(
            value: controller,
            child: const TermDetailsPage(id: termId),
          ),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    group('empty', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setEmptyState();
        await pushTermDetailsPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'terms_details_page_empty_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setEmptyState();
        await pushTermDetailsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'terms_details_page_empty_dark');
      });
    });

    group('with data', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setLoaded();
        await pushTermDetailsPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'terms_details_page_with_data_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setLoaded();
        await pushTermDetailsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'terms_details_page_with_data_dark');
      });
    });

    group('error', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setError();
        await pushTermDetailsPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'terms_details_page_error_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setError();
        await pushTermDetailsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'terms_details_page_error_dark');
      });
    });

    group('loading', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setLoading();
        await pushTermDetailsPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'terms_details_page_loading_light',
            customPump: (tester) =>
                tester.pump(const Duration(milliseconds: 100)));
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setLoading();
        await pushTermDetailsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'terms_details_page_loading_dark',
            customPump: (tester) =>
                tester.pump(const Duration(milliseconds: 100)));
      });
    });
  });
}
