import 'dart:math';

import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/models/subject_id.dart';
import 'package:sharezone/grades/models/term_id.dart';
import 'package:sharezone/grades/pages/grades_page/grades_page.dart';
import 'package:sharezone/grades/pages/grades_page/grades_page_controller.dart';
import 'package:sharezone/grades/pages/grades_view.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'grades_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GradesPageController>()])
void main() {
  group(GradesPage, () {
    late MockGradesPageController controller;

    setUp(() {
      controller = MockGradesPageController();
    });

    void setState(GradesPageState state) {
      // Mockito does not support mocking sealed classes yet, so we have to
      // provide a dummy implementation of the state.
      //
      // Ticket: https://github.com/dart-lang/mockito/issues/675
      provideDummy<GradesPageState>(state);
      when(controller.state).thenReturn(state);
    }

    void setEmptyState() {
      setState(const GradesPageLoaded(currentTerm: null, pastTerms: []));
    }

    void setWithData() {
      final random = Random(42);
      final currentTerm = (
        id: TermId('term-0'),
        displayName: '11/1',
        avgGrade: ('1,4', GradePerformance.good),
        subjects: [
          (
            displayName: 'Deutsch',
            abbreviation: 'DE',
            grade: '2,0',
            design: Design.random(random),
            id: SubjectId('1'),
          ),
          (
            displayName: 'Englisch',
            abbreviation: 'E',
            grade: '2+',
            design: Design.random(random),
            id: SubjectId('2'),
          ),
          (
            displayName: 'Mathe',
            abbreviation: 'DE',
            grade: '1-',
            design: Design.random(random),
            id: SubjectId('3'),
          ),
          (
            displayName: 'Sport',
            abbreviation: 'DE',
            grade: '1,0',
            design: Design.random(random),
            id: SubjectId('4'),
          ),
          (
            displayName: 'Physik',
            abbreviation: 'PH',
            grade: '3,0',
            design: Design.random(random),
            id: SubjectId('5'),
          ),
        ]
      );
      final pastTerms = [
        (
          id: TermId('term-1'),
          displayName: '10/2',
          avgGrade: ('1,0', GradePerformance.good),
        ),
        (
          id: TermId('term-3'),
          displayName: '9/2',
          avgGrade: ('1,0', GradePerformance.good),
        ),
        (
          id: TermId('term-2'),
          displayName: '10/1',
          avgGrade: ('2,4', GradePerformance.satisfactory),
        ),
        (
          id: TermId('term-6'),
          displayName: 'Q1/1',
          avgGrade: ('2,4', GradePerformance.satisfactory),
        ),
        (
          id: TermId('term-5'),
          displayName: '8/2',
          avgGrade: ('1,7', GradePerformance.good),
        ),
        (
          id: TermId('term-4'),
          displayName: '9/1',
          avgGrade: ('3,7', GradePerformance.bad),
        ),
      ];
      setState(
        GradesPageLoaded(
          currentTerm: currentTerm,
          pastTerms: pastTerms,
        ),
      );
    }

    void setWithError() {
      setState(const GradesPageError('An error occurred.'));
    }

    void setWithLoading() {
      setState(const GradesPageLoading());
    }

    Future<void> pushGradesPage(WidgetTester tester, ThemeData theme) async {
      await tester.pumpWidgetBuilder(
        ChangeNotifierProvider<GradesPageController>.value(
          value: controller,
          child: const GradesPageBody(),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    group('empty', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setEmptyState();
        await pushGradesPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'grades_page_empty_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setEmptyState();
        await pushGradesPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'grades_page_empty_dark');
      });
    });

    group('with data', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setWithData();
        await pushGradesPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'grades_page_with_data_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setWithData();
        await pushGradesPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'grades_page_with_data_dark');
      });
    });

    group('error', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setWithError();
        await pushGradesPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'grades_page_error_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setWithError();
        await pushGradesPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'grades_page_error_dark');
      });
    });

    group('loading', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setWithLoading();
        await pushGradesPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'grades_page_loading_light',
            customPump: (tester) =>
                tester.pump(const Duration(milliseconds: 100)));
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setWithLoading();
        await pushGradesPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'grades_page_loading_dark',
            customPump: (tester) =>
                tester.pump(const Duration(milliseconds: 100)));
      });
    });
  });
}
