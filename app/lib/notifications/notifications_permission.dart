// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:sharezone_utils/device_information_manager.dart';
import 'package:sharezone_utils/platform.dart';

class NotificationsPermission {
  final MobileDeviceInformationRetreiver mobileDeviceInformationRetreiver;
  final FirebaseMessaging firebaseMessaging;

  const NotificationsPermission({
    @required this.mobileDeviceInformationRetreiver,
    @required this.firebaseMessaging,
  });

  /// Returns `true` if this device is required to request permission for
  /// notifications.
  Future<bool> isRequiredToRequestPermission() async {
    if (PlatformCheck.isAndroid) {
      final currentAndroidSdk =
          await mobileDeviceInformationRetreiver.androidSdkInt();

      // Android SDK 33 equals Android 13.
      //
      // See: https://developer.android.com/studio/releases/platforms#13
      const android13SdkInt = 33;

      final isAndroid12OrLower = currentAndroidSdk < android13SdkInt;
      if (isAndroid12OrLower) {
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
}
