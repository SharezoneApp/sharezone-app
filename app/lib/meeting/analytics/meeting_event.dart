import 'package:analytics/analytics.dart';
import 'package:sharezone_utils/platform.dart';

class MeetingEvent extends AnalyticsEvent {
  MeetingEvent(String name) : super('meeting_$name');

  @override
  Map<String, dynamic> get data => {"platform": getPlatform().toString()};
}