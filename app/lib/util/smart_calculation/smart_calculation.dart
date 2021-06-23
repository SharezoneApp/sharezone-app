import 'package:meta/meta.dart';
import 'package:sharezone/blocs/dashbord_widgets_blocs/holiday_bloc.dart';
import 'package:date/date.dart';
import 'package:sharezone/models/extern_apis/holiday.dart';
import 'package:sharezone/timetable/src/models/lesson.dart';
import 'package:user/user.dart';

import 'package:sharezone/util/api/timetableGateway.dart';
import 'package:sharezone/util/api/user_api.dart';
import 'package:sharezone/util/holidays/api_cache_manager.dart';
import 'package:sharezone/util/smart_calculation/lesson_calculation.dart';

class SmartCalculations {
  final TimetableGateway timetableGateway;
  final UserGateway userGateway;
  final HolidayManager holidayManager;

  SmartCalculations({
    @required this.timetableGateway,
    @required this.userGateway,
    @required this.holidayManager,
  });

  Future<Date> calculateNextLesson(String courseID) async {
    List<Lesson> lessons = await timetableGateway.getLessonsOfGroup(courseID);
    AppUser user = await userGateway.get();
    List<Holiday> holidays;
    // IN A TRY CATCH LOOP BECAUSE OF STATEENUM THROWS
    try {
      holidays = user.state != null
          ? await holidayManager.load(toStateOrThrow(user.state))
          : [];
    } catch (e) {
      holidays = [];
    }
    NextLessonCalculation nextLessonCalculation =
        NextLessonCalculation(lessons, holidays, user.userSettings);
    List<Date> results = nextLessonCalculation.calculate(days: 3);
    if (results.isEmpty) {
      return null;
    } else {
      print(results);
      return results.first;
    }
  }
}
