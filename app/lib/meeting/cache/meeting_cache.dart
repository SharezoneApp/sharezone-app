import 'package:key_value_store/key_value_store.dart';

class MeetingCache {
  MeetingCache(this.keyValueStore);

  static const _meetingWarningKey = '_meetingWarningKey';
  final KeyValueStore keyValueStore;

  /// Returns [true] if the meeting warning has never been shown to the user.
  /// If it has been shown before, [false] is returned.
  bool hasWarningBeenShown() {
    return keyValueStore.containsKey(_meetingWarningKey);
  }

  void setMeetingWarningAsShown() {
    keyValueStore.setBool(_meetingWarningKey, true);
  }
}