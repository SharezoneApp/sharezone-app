// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:sharezone/timetable/src/models/timetable_element.dart';
import 'package:sharezone/timetable/src/models/timetable_element_properties.dart';
import 'package:time/time.dart';

/// CALCULATES THE DIMENSIONS OF ONE ELEMENT FOR THE TIMETABLE
class TimetableElementDimensions {
  final TimetableElement timetableElement;
  final double hourHeight, totalWidth;
  final Time timetableBegin;

  const TimetableElementDimensions(this.timetableElement, this.hourHeight,
      this.totalWidth, this.timetableBegin);

  double get height {
    final diffHours = timetableElement.end.hour - timetableElement.start.hour;
    final diffMinutes =
        timetableElement.end.minute - timetableElement.start.minute;

    double diffTotalInHours = diffHours + (diffMinutes / 60);
    return diffTotalInHours * hourHeight;
  }

  double get topPosition {
    int startHour = timetableElement.start.hour;
    int startMinutes = timetableElement.start.minute;
    double startHourTotalInHours = startHour + (startMinutes / 60);
    double timetableBeginInHours =
        timetableBegin.hour + (timetableBegin.minute / 60);
    return (startHourTotalInHours - timetableBeginInHours) * hourHeight;
  }

  double get leftPosition {
    final properties = timetableElement.properties;
    if (properties == TimetableElementProperties.standard) {
      return 0.0;
    } else {
      final spacePerIndex = totalWidth / properties.totalsAtThisPosition;
      return properties.index * spacePerIndex;
    }
  }

  double get width {
    final properties = timetableElement.properties;
    if (properties == TimetableElementProperties.standard) {
      return totalWidth;
    } else {
      final spacePerIndex = totalWidth / properties.totalsAtThisPosition;
      return spacePerIndex;
    }
  }
}
