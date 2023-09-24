import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/support/support_page_controller.dart';

void main() {
  group(SupportPageController, () {
    group('getVideoCallAppointmentsUnencodedUrlWithPrefills()', () {
      test('throws $UserNotAuthenticatedException when user Id is null',
          () async {
        final controller = SupportPageController(
          userIdStream: Stream.value(null),
          userNameStream: Stream.value(null),
          userEmailStream: Stream.value(null),
          hasPlusSupportUnlockedStream: Stream.value(false),
          isUserInGroupOnboardingStream: Stream.value(false),
        );

        // Workaround to wait for stream subscription in constructor.
        await Future.delayed(Duration.zero);

        expect(
          () => controller.getVideoCallAppointmentsUnencodedUrlWithPrefills(),
          throwsA(isA<UserNotAuthenticatedException>()),
        );
      });

      test('returns url with user data', () async {
        final controller = SupportPageController(
          userIdStream: Stream.value(UserId('userId123')),
          userNameStream: Stream.value('My Cool Name'),
          userEmailStream: Stream.value('my@email.com'),
          hasPlusSupportUnlockedStream: Stream.value(false),
          isUserInGroupOnboardingStream: Stream.value(false),
        );

        // Workaround to wait for stream subscription in constructor.
        await Future.delayed(Duration.zero);

        expect(
          controller.getVideoCallAppointmentsUnencodedUrlWithPrefills(),
          'https://sharezone.net/sharezone-plus-video-call-support?userId=userId123&name=My Cool Name&email=my@email.com',
        );
      });
    });
  });
}
