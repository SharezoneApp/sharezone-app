import 'package:date/date.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/models/timetable_element.dart';
import 'package:sharezone/timetable/src/widgets/timetable_day_view.dart';
import 'package:sharezone/timetable/src/widgets/timetable_time_view.dart';
import 'package:sharezone/timetable/src/widgets/timetable_weekview_header.dart';
import 'package:user/user.dart';

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
        // Users expect to be able to drag the timetable up and down via mouse as
        // this is old behavior.
        //
        // Flutter had this as a default until they made a breaking change (
        // disable dragging as a default for desktops with mice). So this is a
        // workaround to explicitly re-enable this behavior. See:
        // https://docs.flutter.dev/release/breaking-changes/default-scroll-behavior-drag
        //
        // In the future we might add explicit buttons to go forward or backwards
        // a week in the timetable - in this case we could also only allow
        // scrolling up and down in the timetable via the scroll wheel.
        // If we disable dragging up and down right now it might be confusing if
        // one can drag (horizontally) to the next week via mouse but can only
        // scroll (not drag) up and down.
        scrollBehavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }),
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
