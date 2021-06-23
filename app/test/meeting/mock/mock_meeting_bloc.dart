import 'package:sharezone/meeting/bloc/meeting_bloc.dart';

class MockMeetingBloc implements MeetingBloc {
  bool _shouldShowMeetingWarning = true;
  bool calledMeetingWarningAsAcknowledged = false;
  bool calledJoinGroupMeetingMethod = false;
  Exception _throwExpectionWhenJoinGroupMeeting;

  @override
  Future<void> joinGroupMeeting() async {
    calledJoinGroupMeetingMethod = true;
    if (_throwExpectionWhenJoinGroupMeeting != null) {
      throw _throwExpectionWhenJoinGroupMeeting;
    }
  }

  @override
  void setMeetingWarningWasAcknowledged() {
    _shouldShowMeetingWarning = false;
    calledMeetingWarningAsAcknowledged = true;
  }

  @override
  bool shouldShowMeetingWarning() {
    return _shouldShowMeetingWarning;
  }

  // ignore: use_setters_to_change_properties
  void setShouldShowMeetingWarning(bool value) {
    _shouldShowMeetingWarning = value;
  }

  // ignore: use_setters_to_change_properties
  void shouldThrowExpectionWhenJoinGroupMeeting(Exception e) {
    _throwExpectionWhenJoinGroupMeeting = e;
  }

  @override
  void dispose() {}

  @override
  MeetingBlocParameters get params => throw UnimplementedError();
}
