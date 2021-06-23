import 'package:sharezone/meeting/analytics/meeting_analytics.dart';

class MockMeetingAnalytics implements MeetingAnalytics {
  bool loggedJoinedGroupMeeting = false;

  @override
  void logJoinedGroupMeeting() {
    loggedJoinedGroupMeeting = true;
  }
}
