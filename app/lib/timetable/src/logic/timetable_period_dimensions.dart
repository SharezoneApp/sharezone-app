// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:time/time.dart';
import 'package:user/user.dart';

/// CALCULATES THE DIMENSIONS OF ONE ELEMENT FOR THE TIMETABLE
class TimetablePeriodDimensions {
  final Period period;
  final double hourHeight;
  final Time timetableBegin;

  const TimetablePeriodDimensions(
      this.period, this.hourHeight, this.timetableBegin);

  double get height {
    final diffHours = period.endTime.hour - period.startTime.hour;
    final diffMinutes = period.endTime.minute - period.startTime.minute;

    double diffTotalInHours = diffHours + (diffMinutes / 60);
    return diffTotalInHours * hourHeight;
  }

  double get topPosition {
    int startHour = period.startTime.hour;
    int startMinutes = period.startTime.minute;
    double startHourTotalInHours = startHour + (startMinutes / 60);
    double timetableBeginInHours =
        timetableBegin.hour + (timetableBegin.minute / 60);
    return (startHourTotalInHours - timetableBeginInHours) * hourHeight;
  }
}

class TimetableTimeDimensions {
  final Time time;
  final double hourHeight;
  final Time timetableBegin;

  const TimetableTimeDimensions(
      this.time, this.hourHeight, this.timetableBegin);

  double get topPosition {
    int startHour = time.hour;
    int startMinutes = time.minute;
    double startHourTotalInHours = startHour + (startMinutes / 60);
    double timetableBeginInHours =
        timetableBegin.hour + (timetableBegin.minute / 60);
    return (startHourTotalInHours - timetableBeginInHours) * hourHeight;
  }
}
