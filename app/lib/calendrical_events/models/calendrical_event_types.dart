// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:flutter/material.dart';

abstract class CalendricalEventType {
  String get key;
  String get name;
  IconData get iconData;
  Color get color;

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;
    return other is CalendricalEventType && other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

CalendricalEventType getEventTypeFromString(String data) {
  switch (data) {
    case 'excursion':
      return Excursion();
    case 'exam':
      return Exam();
    case 'meeting':
      return Meeting();
    case 'other':
      return OtherEventType();
    default:
      return OtherEventType();
  }
}

String getEventTypeToString(CalendricalEventType? eventType) {
  return (eventType ?? OtherEventType()).key;
}

class Excursion extends CalendricalEventType {
  @override
  Color color = Colors.blue;

  @override
  IconData iconData = Icons.trip_origin;

  @override
  String key = "excursion";

  @override
  String name = "Ausflug";
}

class Exam extends CalendricalEventType {
  @override
  Color color = Colors.red;

  @override
  IconData iconData = Icons.note;

  @override
  String key = "exam";

  @override
  String name = "Prüfung";
}

class Meeting extends CalendricalEventType {
  @override
  Color color = Colors.orange;

  @override
  IconData iconData = Icons.note;

  @override
  String key = "meeting";

  @override
  String name = "Veranstaltung";
}

class OtherEventType extends CalendricalEventType {
  @override
  Color color = Colors.purple;

  @override
  IconData iconData = Icons.more_vert;

  @override
  String key = "other";

  @override
  String name = "Anderes";
}
