// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/subject_settings_page/subject_settings_page.dart';
import 'package:sharezone/grades/pages/subject_settings_page/subject_settings_page_controller.dart';
import 'package:sharezone/grades/pages/subject_settings_page/subject_settings_page_view.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

import '../../../flutter_test_config.dart';
import 'subject_settings_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubjectSettingsPageController>()])
void main() {
  group(SubjectSettingsPage, () {
    const termId = TermId('term-1');
    const subjectId = SubjectId('subject-1');
    late MockSubjectSettingsPageController controller;

    setUp(() {
      controller = MockSubjectSettingsPageController();
    });

    void setState(SubjectSettingsState state) {
      // Mockito does not support mocking sealed classes yet, so we have to
      // provide a dummy implementation of the state.
      //
      // Ticket: https://github.com/dart-lang/mockito/issues/675
      provideDummy<SubjectSettingsState>(state);
      when(controller.state).thenReturn(state);
    }

    void setLoaded() {
      setState(
        SubjectSettingsLoaded(
          SubjectSettingsPageView(
            subjectName: 'Mathe',
            finalGradeTypeDisplayName: 'Zeugnisnote',
            finalGradeTypeIcon: const Icon(Icons.edit_document),
            selectableGradingTypes: const IListConst([]),
            weights: IMapConst({
              GradeType.oralParticipation.id: const Weight.factor(0.5),
              GradeType.writtenExam.id: const Weight.factor(1),
            }),
          ),
        ),
      );
    }

    void setError() {
      setState(const SubjectSettingsError('An error occurred.'));
    }

    void setLoading() {
      setState(const SubjectSettingsLoading());
    }

    Future<void> pushSubjectSettingsPage(
      WidgetTester tester,
      ThemeData theme,
    ) async {
      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            Provider<GradesService>(create: (_) => GradesService()),
            ChangeNotifierProvider<SubjectSettingsPageController>.value(
              value: controller,
            ),
          ],
          child: const SubjectSettingsPage(
            termId: termId,
            subjectId: subjectId,
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
        await pushSubjectSettingsPage(tester, getLightTheme());
        await multiScreenGolden(
          tester,
          'subject_settings_page_with_data_light',
        );
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setLoaded();
        await pushSubjectSettingsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'subject_settings_page_with_data_dark');
      });
    });

    group('error', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setError();
        await pushSubjectSettingsPage(tester, getLightTheme());
        await multiScreenGolden(tester, 'subject_settings_page_error_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setError();
        await pushSubjectSettingsPage(tester, getDarkTheme());
        await multiScreenGolden(tester, 'subject_settings_page_error_dark');
      });
    });

    group('loading', () {
      testGoldens('renders as expected (light mode)', (tester) async {
        setLoading();
        await pushSubjectSettingsPage(tester, getLightTheme());
        await multiScreenGolden(
          tester,
          'subject_settings_page_loading_light',
          customPump:
              (tester) => tester.pump(const Duration(milliseconds: 100)),
        );
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        setLoading();
        await pushSubjectSettingsPage(tester, getDarkTheme());
        await multiScreenGolden(
          tester,
          'subject_settings_page_loading_dark',
          customPump:
              (tester) => tester.pump(const Duration(milliseconds: 100)),
        );
      });
    });
  });
}
