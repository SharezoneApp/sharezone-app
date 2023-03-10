import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/notifications/notifications_permission.dart';
import 'package:sharezone_utils/device_information_manager.dart';
import 'package:sharezone_utils/platform.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

void main() {
  group('NotificationPermission', () {
    MockFirebaseMessaging firebaseMessaging;
    MockMobileDeviceInformationRetreiver mobileDeviceInformationRetreiver;

    NotificationsPermission notificationsPermission;

    setUp(() {
      firebaseMessaging = MockFirebaseMessaging();
      mobileDeviceInformationRetreiver = MockMobileDeviceInformationRetreiver();

      notificationsPermission = NotificationsPermission(
        firebaseMessaging: firebaseMessaging,
        mobileDeviceInformationRetreiver: mobileDeviceInformationRetreiver,
      );
    });

    test(
      'returns false when checking if Android 12 requires to request permission',
      () async {
        PlatformCheck.setCurrentPlatformForTesting(Platform.android);
        mobileDeviceInformationRetreiver.setAndroidSdkInt(32);

        final isRequired =
            await notificationsPermission.isRequiredToRequestPermission();

        expect(isRequired, isFalse);
      },
    );

    test(
      'returns true when checking if Android 13 requires to request permission',
      () async {
        PlatformCheck.setCurrentPlatformForTesting(Platform.android);
        mobileDeviceInformationRetreiver.setAndroidSdkInt(33);

        final isRequired =
            await notificationsPermission.isRequiredToRequestPermission();

        expect(isRequired, isTrue);
      },
    );

    test(
      'returns true when checking if iOS requires to request permission',
      () async {
        PlatformCheck.setCurrentPlatformForTesting(Platform.iOS);

        final isRequired =
            await notificationsPermission.isRequiredToRequestPermission();

        expect(isRequired, isTrue);
      },
    );

    test(
      'returns true when checking if macOS requires to request permission',
      () async {
        PlatformCheck.setCurrentPlatformForTesting(Platform.macOS);

        final isRequired =
            await notificationsPermission.isRequiredToRequestPermission();

        expect(isRequired, isTrue);
      },
    );

    test(
      'returns true when checking if web requires to request permission',
      () async {
        PlatformCheck.setCurrentPlatformForTesting(Platform.web);

        final isRequired =
            await notificationsPermission.isRequiredToRequestPermission();

        expect(isRequired, isTrue);
      },
    );

    test('requests permission for notifications', () async {
      await notificationsPermission.requestPermission();

      verify(firebaseMessaging.requestPermission());
    });
  });
}
