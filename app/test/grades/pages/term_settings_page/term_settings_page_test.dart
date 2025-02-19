// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller_factory.dart';

import '../../../../test_goldens/grades/pages/term_settings_page/term_settings_page_test.dart';
import '../../../../test_goldens/grades/pages/term_settings_page/term_settings_page_test.mocks.dart';

void main() {
  group('$TermSettingsPage', () {
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

    Future<void> pumpTermSettingsPage(WidgetTester tester) async {
      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            Provider<GradesService>(create: (_) => GradesService()),
            Provider<TermSettingsPageControllerFactory>.value(
              value: controllerFactory,
            ),
          ],
          child: const TermSettingsPage(termId: termId),
        ),
        wrapper: materialAppWrapper(),
      );
    }

    testWidgets(
      'if $WeightDisplayType is ${WeightDisplayType.factor} the factor dialog will be shown when tapping subject weight',
      (tester) async {
        expect(loadedState2.view.weightDisplayType, WeightDisplayType.factor);
        setState(loadedState2);
        await pumpTermSettingsPage(tester);

        final germanSubjectFinder = find.text('Deutsch');
        tester.ensureVisible(germanSubjectFinder);
        await tester.tap(find.text("Deutsch"));
        await tester.pumpAndSettle();

        Finder findInDialog(Finder finder) => find.descendant(
          of: find.byWidgetPredicate((widget) => widget is Dialog),
          matching: finder,
        );
        // We want to show "1.0" instead of "1" so that the user knows what the
        // decimal separator is ("." instead of ",").
        expect(findInDialog(find.text('1.0')), findsOneWidget);
        expect(findInDialog(find.text('%')), findsNothing);
      },
    );
    testWidgets(
      'if $WeightDisplayType is ${WeightDisplayType.percent} the percent dialog will be shown when tapping subject weight',
      (tester) async {
        expect(loadedState1.view.weightDisplayType, WeightDisplayType.percent);
        setState(loadedState1);

        await pumpTermSettingsPage(tester);

        final germanSubjectFinder = find.text('Deutsch');
        tester.ensureVisible(germanSubjectFinder);
        await tester.tap(find.text("Deutsch"));
        await tester.pumpAndSettle();

        Finder findInDialog(Finder finder) => find.descendant(
          of: find.byWidgetPredicate((widget) => widget is Dialog),
          matching: finder,
        );
        expect(findInDialog(find.text('100')), findsOneWidget);
        // We add "%" as a suffix to the text field
        expect(findInDialog(find.text('%')), findsOneWidget);
      },
    );
  });
}
