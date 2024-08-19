import 'dart:math';

import 'package:design/design.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller_factory.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_view.dart';

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
              Provider<GradesService>(
                create: (_) => GradesService(),
              ),
              Provider<TermSettingsPageControllerFactory>.value(
                value: controllerFactory,
              ),
            ],
            child: const TermSettingsPage(termId: termId),
          ),
          wrapper: materialAppWrapper());
    }

    void setLoaded2() {
      final random = Random(35);
      setState(
        TermSettingsLoaded(
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
                design: Design.random(random),
                id: const SubjectId('d'),
                weight: const Weight.factor(1),
              ),
              (
                displayName: 'Englisch',
                abbreviation: 'E',
                design: Design.random(random),
                id: const SubjectId('e'),
                weight: const Weight.factor(2),
              ),
            ]),
          ),
        ),
      );
    }

    testWidgets(
        'if $WeightDisplayType is ${WeightDisplayType.factor} the factor dialog will be shown when tapping subject weight',
        (tester) async {
      setLoaded2();
      await pumpTermSettingsPage(tester);

      final germanSubjectFinder = find.text('Deutsch');
      tester.ensureVisible(germanSubjectFinder);
      await tester.tap(find.text("Deutsch"));
      await tester.pumpAndSettle();

      Finder findInDialog(Finder finder) => find.descendant(
            of: find.byWidgetPredicate((widget) => widget is Dialog),
            matching: finder,
          );
      expect(findInDialog(find.text('1.0')), findsOneWidget);
      expect(findInDialog(find.text('%')), findsNothing);
    });
  });
}
