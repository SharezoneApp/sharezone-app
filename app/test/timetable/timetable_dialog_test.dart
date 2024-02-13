import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/timetable/timetable_add_event/timetable_add_event_dialog.dart';

void main() {
  group('event add dialog', () {
    testWidgets('shows empty event state if `isExam` is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimetableAddEventDialog(isExam: false),
          ),
        ),
      );

      expect(find.textContaining('Termin'), findsOneWidget);
    });
  });
}
