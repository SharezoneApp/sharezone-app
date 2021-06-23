import 'package:date/date.dart';
import 'package:user/user.dart';

class TimetableDateHelper {
  static Date dateBeginThisWeek() {
    Date today = Date.today();
    Date startOfThisWeek = today.addDays(-(today.weekDay - 1));
    return startOfThisWeek;
  }

  static Date dateAddDays(Date date, int days) {
    return date.addDays(days);
  }

  static Date dateAddWeeks(Date date, int weeks) {
    return dateAddDays(date, weeks * 7);
  }

  // THERE ARE MORE OPTIMAL CALCULATION METHODES, BUT I LIKE THIS DESIGN :)
  static List<Date> generateDaysList(
      Date startDate, Date endDate, EnabledWeekDays enabledWeekDays) {
    DateTime startDateTime = startDate.toDateTime;
    DateTime endDateTime = endDate.toDateTime;
    int days = endDateTime.difference(startDateTime).inDays.abs() + 1;
    return List.generate(days,
            (it) => Date.fromDateTime(startDateTime.add(Duration(days: it))))
        .where((it) => enabledWeekDays.getValue(it.weekDayEnum))
        .toList();
  }

  static String getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'Mo';
      case 2:
        return 'Di';
      case 3:
        return 'Mi';
      case 4:
        return 'Do';
      case 5:
        return 'Fr';
      case 6:
        return 'Sa';
      case 7:
        return 'So';
      default:
        return "falsedayValue!";
    }
  }
}
