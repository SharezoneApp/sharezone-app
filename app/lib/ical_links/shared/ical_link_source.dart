import 'package:flutter/material.dart';

/// The sources for which an iCal link includes.
enum ICalLinkSource {
  exams,
  meetings,
  lessons;

  String getUiName() {
    return switch (this) {
      ICalLinkSource.lessons => 'Schulstunden',
      ICalLinkSource.exams => 'Prüfungen',
      ICalLinkSource.meetings => 'Termine',
    };
  }

  Widget getIcon() {
    return switch (this) {
      ICalLinkSource.lessons => const Icon(Icons.timelapse),
      ICalLinkSource.exams => const Icon(Icons.school),
      ICalLinkSource.meetings => const Icon(Icons.event),
    };
  }
}
