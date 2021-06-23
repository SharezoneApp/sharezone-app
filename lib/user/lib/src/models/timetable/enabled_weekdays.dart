import 'package:date/weekday.dart';
import 'package:sharezone_common/helper_functions.dart';

const weekDayDefaults = {
  WeekDay.monday: true,
  WeekDay.tuesday: true,
  WeekDay.wednesday: true,
  WeekDay.thursday: true,
  WeekDay.friday: true,
  WeekDay.saturday: false,
  WeekDay.sunday: false,
};

class EnabledWeekDays {
  final Map<String, bool> _internalMap;

  const EnabledWeekDays._(this._internalMap);

  static const EnabledWeekDays standard = EnabledWeekDays._({});

  factory EnabledWeekDays.fromData(Map<String, dynamic> data) {
    return EnabledWeekDays._(decodeMap<bool>(data, (key, value) => value));
  }

  bool getValue(WeekDay weekDay) {
    return _internalMap[weekDayEnumToString(weekDay)] ??
        weekDayDefaults[weekDay];
  }

  EnabledWeekDays copyWith(WeekDay weekDay, bool newValue) {
    final newMap = Map.of(_internalMap);
    newMap[weekDayEnumToString(weekDay)] = newValue;
    return EnabledWeekDays._(newMap);
  }

  List<WeekDay> getEnabledWeekDaysList() {
    return WeekDay.values.where((it) => getValue(it)).toList();
  }

  Map<String, bool> toJson() {
    return _internalMap;
  }
}
