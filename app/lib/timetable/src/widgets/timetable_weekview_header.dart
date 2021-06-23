import 'package:flutter/material.dart';
import 'package:date/date.dart';
import 'package:date/weekday.dart';
import 'package:date/weektype.dart';
import 'package:sharezone/timetable/src/bloc/timetable_bloc.dart';
import 'package:sharezone/timetable/src/edit_weektype.dart';
import 'package:sharezone/timetable/src/widgets/timtable_weekview_day_tile.dart';
import 'package:sharezone_widgets/theme.dart';

const _headerHeight = 50.0;

class TimetableWeekViewHeader extends SliverPersistentHeaderDelegate {
  final List<Date> dates;

  TimetableWeekViewHeader({@required this.dates});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Theme.of(context).appBarTheme.color,
      elevation: 1,
      child: Center(
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: TimetableConfigBuilder(
                  builder: (context, config) {
                    final WeekType currentWeekType =
                        config.getWeekType(dates.first);
                    return currentWeekType == WeekType.always
                        ? Container()
                        : Center(
                            child: Text(
                              getWeekTypeTextShort(currentWeekType),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkThemeEnabled(context)
                                      ? Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .color
                                      : Theme.of(context)
                                          .appBarTheme
                                          .textTheme
                                          .headline6
                                          .color),
                            ),
                          );
                  },
                )),
            for (final date in dates)
              TimetableWeekViewDayTile(
                date: date,
                showMonthName: _showMonthName(date, dates),
                isToday: _isToday(date),
              ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
    );
  }

  @override
  double get maxExtent => _headerHeight;

  @override
  double get minExtent => _headerHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

bool _isToday(Date date) {
  return date == Date.today();
}

bool _showMonthName(Date date, List<Date> dates) {
  if (date.dayOfMonth == 1) return true;
  if (date.weekDayEnum == WeekDay.monday) {
    return dates.where((it) => it.dayOfMonth == 1).isEmpty;
  }
  return false;
}
