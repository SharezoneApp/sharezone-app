import 'dart:convert';

import 'package:home_widget/home_widget.dart';
import 'package:sharezone/dashboard/timetable/lesson_view.dart';

/// Saves today's lessons to shared App Group storage and updates the widget.
Future<void> updateTimetableWidget(List<LessonView> lessons) async {
  final serialized = [
    for (final l in lessons)
      {
        'start': l.start,
        'end': l.end,
        'abbr': l.abbreviation,
      }
  ];

  await HomeWidget.saveWidgetData<String>('timetable', jsonEncode(serialized));
  await HomeWidget.updateWidget(
    name: 'TimetableWidget',
    iOSName: 'TimetableWidget',
  );
}
