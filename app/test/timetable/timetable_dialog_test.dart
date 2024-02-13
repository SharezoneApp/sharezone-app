import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/timetable/timetable_add_event/timetable_add_event_dialog.dart';

void main() {
  group('event add dialog', () {
    Future<void> pumpDialog(WidgetTester tester,
        {required bool isExam, AddEventDialogController? controller}) async {
      controller ??= AddEventDialogController();

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => controller,
          child: MaterialApp(
            home: Scaffold(
              body: TimetableAddEventDialog(isExam: isExam),
            ),
          ),
        ),
      );
    }

    testWidgets('shows empty event state if `isExam` is false', (tester) async {
      await pumpDialog(tester, isExam: false);

      expect(find.textContaining('Termin'), findsWidgets);
      expect(find.textContaining('Klausur'), findsNothing);
    });
    testWidgets('shows empty exam state if `isExam` is true', (tester) async {
      await pumpDialog(tester, isExam: true);

      expect(find.textContaining('Klausur'), findsWidgets);
      expect(find.textContaining('Termin'), findsNothing);
    });

    testWidgets('entered title is forwarded to controller', (tester) async {
      final controller = AddEventDialogController();
      await pumpDialog(tester, isExam: false, controller: controller);

      await tester.enterText(
          find.byKey(EventDialogKeys.titleTextField), 'Test');

      expect(find.text('Test'), findsOneWidget);
      expect(controller.title, 'Test');
    });

    testWidgets('entered description is forwarded to controller',
        (tester) async {
      final controller = AddEventDialogController();
      await pumpDialog(tester, isExam: false, controller: controller);

      await tester.enterText(
          find.byKey(EventDialogKeys.descriptionTextField), 'Test description');

      expect(find.text('Test description'), findsOneWidget);
      expect(controller.description, 'Test description');
    });
  });
}
