import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:key_value_store/in_memory_key_value_store.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/meeting/bloc/meeting_bloc.dart';
import 'package:sharezone/meeting/cache/meeting_cache.dart';
import 'package:sharezone/meeting/jitsi/jitsi_auth.dart';
import 'package:sharezone/meeting/jitsi/jitsi_launcher.dart';
import 'package:sharezone/meeting/models/meeting_id.dart';
import 'package:sharezone_utils/device_information_manager.dart';
import 'package:sharezone_utils/platform.dart';

import 'mock_meeting_analytics.dart';

void main() {
  group('MeetingBloc', () {
    MockMeetingAnalytics analyitcs;
    MeetingCache cache;
    MockJitsiLauncher jitsiLauncher;
    MockJitsiAuth jitsiAuth;
    MockMobileDeviceInformationRetreiver mobileDeviceInfo;

    const serverUrl = "https://mock.meet.sharezone.net";

    MeetingBloc createBloc({
      @required GroupId groupId,
      @required GroupType groupType,
      @required MeetingId meetingId,
      @required String groupName,
    }) {
      final params = MeetingBlocParameters(
        meetingCache: cache,
        analytics: analyitcs,
        jitsiAuth: jitsiAuth,
        jitsiLauncher: jitsiLauncher,
        mobileDeviceInfo: mobileDeviceInfo,
        meetingId: meetingId,
        groupId: groupId,
        groupType: groupType,
        groupName: groupName,
      );
      return MeetingBloc(params);
    }

    /// Creates a [MeetingBloc] with default values.
    MeetingBloc defaultBloc() {
      return createBloc(
        groupId: GroupId("groupId"),
        groupName: "groupName",
        meetingId: MeetingId("123456789"),
        groupType: GroupType.course,
      );
    }

    setUp(() {
      cache = MeetingCache(InMemoryKeyValueStore());
      analyitcs = MockMeetingAnalytics();
      jitsiLauncher = MockJitsiLauncher(serverUrl);
      jitsiAuth = MockJitsiAuth();
      mobileDeviceInfo = MockMobileDeviceInformationRetreiver();
    });

    test('logs analytics when user joins a meeting', () async {
      await defaultBloc().joinGroupMeeting();
      expect(analyitcs.loggedJoinedGroupMeeting, true);
    });

    test('calls JitsiService join mobile method, if device is iOS', () async {
      PlatformCheck.setCurrentPlatformForTesting(Platform.iOS);
      expect(jitsiLauncher.logCalledJoinMobileMeeting, false);

      await defaultBloc().joinGroupMeeting();

      expect(jitsiLauncher.logCalledJoinMobileMeeting, true);
    });

    test(
        'calls JitsiService join mobile method, if device is android and android sdk is not lower than 23',
        () async {
      PlatformCheck.setCurrentPlatformForTesting(Platform.android);
      mobileDeviceInfo.setAndroidSdkInt(23);
      expect(jitsiLauncher.logCalledJoinMobileMeeting, false);

      await defaultBloc().joinGroupMeeting();

      expect(jitsiLauncher.logCalledJoinMobileMeeting, true);
    });

    test(
        'calls JitsiService join browser method, if device is android and android sdk is lower than 23',
        () async {
      PlatformCheck.setCurrentPlatformForTesting(Platform.android);
      mobileDeviceInfo.setAndroidSdkInt(22);
      expect(jitsiLauncher.logCalledJoinBrowserMeeting, false);

      await defaultBloc().joinGroupMeeting();

      expect(jitsiLauncher.logCalledJoinBrowserMeeting, true);
    });

    test('calls JitsiService join browser method, if device is web', () async {
      PlatformCheck.setCurrentPlatformForTesting(Platform.web);
      expect(jitsiLauncher.logCalledJoinBrowserMeeting, false);

      await defaultBloc().joinGroupMeeting();

      expect(jitsiLauncher.logCalledJoinBrowserMeeting, true);
    });

    test('calls JitsiService join browser method, if device is macos',
        () async {
      PlatformCheck.setCurrentPlatformForTesting(Platform.macOS);
      expect(jitsiLauncher.logCalledJoinBrowserMeeting, false);

      await defaultBloc().joinGroupMeeting();

      expect(jitsiLauncher.logCalledJoinBrowserMeeting, true);
    });
  });
}

class MockJitsiAuth implements JitsiAuth {
  @override
  Future<String> getToken(GroupId groupId, GroupType groupType) async {
    return "jwt";
  }
}

class MockJitsiLauncher implements JitsiLauncher {
  final String serverUrl;

  bool logCalledJoinMobileMeeting = false;

  bool logCalledJoinBrowserMeeting = false;

  MockJitsiLauncher(this.serverUrl);

  @override
  Future<void> joinMobileMeeting({
    @required String meetingId,
    @required String meetingName,
    @required String jwt,
  }) async {
    logCalledJoinMobileMeeting = true;
  }

  @override
  String getMeetingUrl(String meetingId, String jwt) {
    return '$serverUrl/$meetingId?jwt=$jwt';
  }

  @override
  Future<void> joinBrowserMeeting({String meetingId, String jwt}) async {
    logCalledJoinBrowserMeeting = true;
  }
}
