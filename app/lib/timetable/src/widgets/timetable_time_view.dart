// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/settings/periods_edit_page.dart';
import 'package:sharezone/timetable/src/logic/timetable_period_dimensions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:time/time.dart';
import 'package:user/user.dart';

/// THIS IS THE LEFT SECTION OF THE TIMETABLE WHERE THE TIME IS DISPLAYED
class TimetablePeriodView extends StatelessWidget {
  final double hourHeight;
  final Time timetableBegin;
  final Periods periods;

  const TimetablePeriodView({
    required this.hourHeight,
    required this.timetableBegin,
    required this.periods,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: InkWell(
        onTap: () => openPeriodsEditPage(context),
        child: Stack(
          children: [
            for (final period in periods.getPeriods())
              _PositionedPeriodTile(
                period: period,
                timetableBegin: timetableBegin,
                hourHeight: hourHeight,
              ),
            for (int i = 0; i < 24; i++)
              if (!periods.isCloseToAnyPeriod(Time(hour: i, minute: 0)))
                _PositionedHourTile(
                  hour: Time(hour: i, minute: 0),
                  hourHeight: hourHeight,
                  timetableBegin: timetableBegin,
                ),
          ],
        ),
      ),
    );
  }
}

class _PositionedPeriodTile extends StatelessWidget {
  final Period period;
  final double hourHeight;
  final Time timetableBegin;

  const _PositionedPeriodTile({
    Key? key,
    required this.period,
    required this.hourHeight,
    required this.timetableBegin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimensions =
        TimetablePeriodDimensions(period, hourHeight, timetableBegin);
    return Positioned(
      left: 0.0,
      top: dimensions.topPosition,
      right: 0.0,
      height: dimensions.height,
      child: _PeriodTile(period: period),
    );
  }
}

class _PositionedHourTile extends StatelessWidget {
  final Time hour;
  final double hourHeight;
  final Time timetableBegin;

  const _PositionedHourTile({
    Key? key,
    required this.hour,
    required this.hourHeight,
    required this.timetableBegin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimensions =
        TimetableTimeDimensions(hour, hourHeight, timetableBegin);
    return Positioned(
      left: 0.0,
      top: dimensions.topPosition,
      right: 0.0,
      child: _HourTile(hour: hour),
    );
  }
}

class _PeriodTile extends StatelessWidget {
  final Period period;

  const _PeriodTile({
    Key? key,
    required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              period.startTime.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                period.number.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  // color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              period.endTime.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkThemeEnabled(context) ? Colors.white30 : Colors.black,
          width: 0.1,
        ),
      ),
    );
  }
}

class _HourTile extends StatelessWidget {
  final Time hour;

  const _HourTile({
    Key? key,
    required this.hour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        hour.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: Colors.grey),
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color:
                  isDarkThemeEnabled(context) ? Colors.white30 : Colors.black,
              width: 0.1),
        ),
      ),
    );
  }
}
