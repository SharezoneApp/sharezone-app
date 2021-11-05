import 'package:bloc_base/bloc_base.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/meeting/analytics/meeting_analytics.dart';
import 'package:sharezone/meeting/cache/meeting_cache.dart';
import 'package:sharezone/meeting/jitsi/jitsi_auth.dart';
import 'package:sharezone/meeting/jitsi/jitsi_launcher.dart';
import 'package:sharezone/meeting/models/meeting_id.dart';
import 'package:sharezone_utils/device_information_manager.dart';
import 'package:sharezone_utils/platform.dart';

class MeetingBlocParameters {
  final MeetingCache meetingCache;
  final MeetingAnalytics analytics;
  final JitsiAuth jitsiAuth;
  final JitsiLauncher jitsiLauncher;
  final MobileDeviceInformationRetreiver mobileDeviceInfo;

  final MeetingId meetingId;
  final GroupId groupId;
  final GroupType groupType;
  final String groupName;

  MeetingBlocParameters({
    @required this.meetingCache,
    @required this.analytics,
    @required this.jitsiAuth,
    @required this.jitsiLauncher,
    @required this.mobileDeviceInfo,
    @required this.meetingId,
    @required this.groupId,
    @required this.groupType,
    @required this.groupName,
  });
}

class MeetingBloc extends BlocBase {
  final MeetingBlocParameters params;

  MeetingBloc(this.params);

  bool shouldShowMeetingWarning() => !params.meetingCache.hasWarningBeenShown();
  void setMeetingWarningWasAcknowledged() =>
      params.meetingCache.setMeetingWarningAsShown();

  Future<void> joinGroupMeeting() async {
    _logJoinedMeeting();

    final token =
        await params.jitsiAuth.getToken(params.groupId, params.groupType);

    if (await _canLaunchJitsiMobileSdk()) {
      await params.jitsiLauncher.joinMobileMeeting(
        meetingId: params.meetingId.id,
        meetingName: params.groupName,
        jwt: token,
      );
    } else {
      // If Jitsi Mobile SDK is not available the meeting should be launched in
      // the browser.
      await params.jitsiLauncher.joinBrowserMeeting(
        meetingId: params.meetingId.id,
        jwt: token,
      );
    }
  }

  void _logJoinedMeeting() {
    params.analytics.logJoinedGroupMeeting();
  }

  /// Jitsi provides a Mobile SDK for Android (min. SDK 23) and iOS. If the
  /// current device supports the Mobile SDK it return true. In other cases
  /// false will be turned.
  Future<bool> _canLaunchJitsiMobileSdk() async {
    if (PlatformCheck.isDesktopOrWeb) return false;
    if (PlatformCheck.isAndroid) {
      final androidSdkIn = await params.mobileDeviceInfo.androidSdkInt();
      if (androidSdkIn < 23) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {}
}
