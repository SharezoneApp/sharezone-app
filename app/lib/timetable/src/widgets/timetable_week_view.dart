import 'package:flutter/material.dart';
import 'package:date/date.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:user/user.dart';
import 'package:sharezone/timetable/src/models/timetable_element.dart';
import 'package:sharezone/timetable/src/widgets/timetable_day_view.dart';
import 'package:sharezone/timetable/src/widgets/timetable_time_view.dart';
import 'package:sharezone/timetable/src/widgets/timetable_weekview_header.dart';

class TimetableWeekView extends StatelessWidget {
  final List<Date> dates;
  final List<TimetableElement> elements;
  final Periods periods;
  final TimetableConfig config;

  const TimetableWeekView({
    @required this.dates,
    @required this.elements,
    @required this.config,
    @required this.periods,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final totalWidth = constraints.maxWidth * (13 / 15);
      return CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: TimetableWeekViewHeader(dates: dates),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: timetableTotalHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TimetablePeriodView(
                    hourHeight: hourHeight,
                    timetableBegin: config.getTimetableStartTime(),
                    periods: periods,
                  ),
                  for (final date in dates)
                    TimetableDayView(
                      date: date,
                      weekType: config.getWeekType(date),
                      width: totalWidth / dates.length,
                      hourHeight: hourHeight,
                      timetableBegin: config.getTimetableStartTime(),
                      elements: elements
                          .where((entry) => entry.date == date)
                          .toList(),
                      periods: periods,
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  double get hourHeight => 60.0 * config.timetableScale;

  double get timetableTotalHeight =>
      hourHeight *
      ((24 - config.getTimetableStartTime().hour) -
          (config.getTimetableStartTime().minute / 60));
}
