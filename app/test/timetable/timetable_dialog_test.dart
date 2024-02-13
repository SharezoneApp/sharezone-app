import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/timetable/timetable_add_event/timetable_add_event_dialog.dart';

void main() {
  group('event add dialog', () {
    Future<void> pumpDialog(WidgetTester tester, {required bool isExam}) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimetableAddEventDialog(isExam: isExam),
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

    testWidgets('can enter text', (tester) async {
      await pumpDialog(tester, isExam: false);

      await tester.enterText(
          find.byKey(EventDialogKeys.titleTextField), 'Test');

      expect(find.text('Test'), findsOneWidget);
    });
  });
}
