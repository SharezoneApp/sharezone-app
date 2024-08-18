import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller_factory.dart';

import '../../../../test_goldens/grades/pages/term_settings_page/term_settings_page_test.mocks.dart';
import '../../../homework/homework_dialog_test.dart';

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

    Future<void> pumpTermSettingsPage(WidgetTester tester) async {
      await tester.pumpWidget(
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
      );
    }

    testWidgets(
        'if $WeightDisplayType is ${WeightDisplayType.factor} the factor dialog will be shown when tapping subject weight',
        (tester) async {
      await pumpTermSettingsPage(tester);
    });
  });
}
