import 'package:flutter/material.dart';

/// The sources for which an iCal export can be created.
///
/// A user can decide which sources to include in the export. For example, a
/// user might want to include exams, but not meetings.
enum ICalExportSource {
  exams,
  meetings;

  String getUiName() {
    return switch (this) {
      ICalExportSource.exams => 'Prüfungen',
      ICalExportSource.meetings => 'Termine',
    };
  }

  Widget getIcon() {
    return switch (this) {
      ICalExportSource.exams => const Icon(Icons.school),
      ICalExportSource.meetings => const Icon(Icons.event),
    };
  }
}
