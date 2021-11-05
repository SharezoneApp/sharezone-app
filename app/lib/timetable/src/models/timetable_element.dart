import 'package:date/date.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone/timetable/src/models/timetable_element_properties.dart';
import 'package:time/time.dart';

class TimetableElement {
  final Date date;
  final GroupInfo groupInfo;
  final Time start;
  final Time end;
  final dynamic data;
  final int priority;
  final TimetableElementProperties properties;

  const TimetableElement({
    this.date,
    this.start,
    this.end,
    this.groupInfo,
    this.data,
    this.priority = 0,
    this.properties = TimetableElementProperties.standard,
  });
}
