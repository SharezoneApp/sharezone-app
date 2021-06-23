import 'package:analytics/analytics.dart';

import 'meeting_event.dart';

class MeetingAnalytics {
  final Analytics _analytics;

  MeetingAnalytics(this._analytics);

  void logJoinedGroupMeeting() {
    _analytics.log(MeetingEvent('group_joined'));
  }
}
