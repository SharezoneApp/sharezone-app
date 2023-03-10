import 'package:bloc_base/bloc_base.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:sharezone_utils/device_information_manager.dart';
import 'package:sharezone_utils/platform.dart';

class NotificationsPermission extends BlocBase {
  final MobileDeviceInformationRetreiver mobileDeviceInformationRetreiver;
  final FirebaseMessaging firebaseMessaging;

  NotificationsPermission({
    @required this.mobileDeviceInformationRetreiver,
    @required this.firebaseMessaging,
  });

  /// Returns `true` if this device is required to request permission for
  /// notifications.
  Future<bool> isRequiredToRequestPermission() async {
    if (PlatformCheck.isAndroid) {
      final androidInfo = await mobileDeviceInformationRetreiver.androidInfo;

      // Android SDK 33 equals Android 13.
      //
      // See: https://developer.android.com/studio/releases/platforms#13
      const android13SdkInt = 33;

      final isAndroid12OrLower = androidInfo.version.sdkInt < android13SdkInt;
      if (!isAndroid12OrLower) {
        // Android 12 and lower don't need to request permission.
        return false;
      }
    }

    return true;
  }

  Future<void> requestPermission() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  @override
  void dispose() {}
}
