import 'package:date/weekday.dart';
import 'package:date/weektype.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/blocs/dashbord_widgets_blocs/holiday_bloc.dart';
import 'package:date/date.dart';
import 'package:sharezone/models/extern_apis/holiday.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:user/user.dart';

import 'package:sharezone/util/api/timetableGateway.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone/util/holidays/api_cache_manager.dart';

class NextLessonCalculator {
  final TimetableGateway timetableGateway;
  final UserGateway userGateway;
  final HolidayManager holidayManager;

  NextLessonCalculator({
    @required this.timetableGateway,
    @required this.userGateway,
    @required this.holidayManager,
  });

  Future<Date> calculateNextLesson(String courseID) async {
    List<Lesson> lessons = await timetableGateway.getLessonsOfGroup(courseID);
    AppUser user = await userGateway.get();
    List<Holiday> holidays;
    try {
      holidays = user.state != null
          ? await holidayManager.load(toStateOrThrow(user.state))
          : [];
    } catch (e) {
      holidays = [];
    }
    _NextLessonCalculation nextLessonCalculation =
        _NextLessonCalculation(lessons, holidays, user.userSettings);
    List<Date> results = nextLessonCalculation.calculate(days: 3);
    if (results.isEmpty) {
      return null;
    } else {
      return results.first;
    }
  }
}

class _NextLessonCalculation {
  final List<Lesson> lessons;
  final List<Holiday> holidays;
  final UserSettings userSettings;

  _NextLessonCalculation(this.lessons, this.holidays, this.userSettings);

  List<Date> calculate({int days = 3}) {
    if (lessons.isEmpty) return [];
    List<Date> results = [];
    Date date = Date.today();
    while (results.length < days) {
      // LOOP TO NEXT DAY
      date = date.addDays(1);
      // CHECKS IF IS HOLIDAY
      if (_isHolidayAt(date)) continue;
      if (!_areLessonsAt(date)) continue;
      // ADDS DATE TO RESULTS
      results.add(date);
    }
    return results;
  }

  bool _areLessonsAt(Date date) {
    WeekType weekType = userSettings.getWeekTypeOfDate(date);
    WeekDay weekDay = WeekDay.values[date.weekDay - 1];
    for (final lesson in lessons) {
      if (weekDay != lesson.weekday) continue;
      if (lesson.weektype == WeekType.always || weekType == WeekType.always)
        return true;
      if (weekType == lesson.weektype) return true;
    }
    return false;
  }

  bool _isHolidayAt(Date date) {
    for (final holiday in holidays) {
      Date start = Date.fromDateTime(holiday.start);
      Date end = Date.fromDateTime(holiday.end);
      if (date.isInsideDateRange(start, end)) return true;
    }
    return false;
  }
}
