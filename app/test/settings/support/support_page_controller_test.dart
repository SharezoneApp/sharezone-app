// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sharezone/support/support_page_controller.dart';
import 'package:url_launcher_extended/url_launcher_extended.dart';
import 'package:user/user.dart';

import 'support_page_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UrlLauncherExtended>()])
void main() {
  group(SupportPageController, () {
    late MockUrlLauncherExtended urlLauncher;

    setUp(() {
      urlLauncher = MockUrlLauncherExtended();
    });

    group('getVideoCallAppointmentsUnencodedUrlWithPrefills()', () {
      test(
        'throws $UserNotAuthenticatedException when user Id is null',
        () async {
          final controller = SupportPageController(
            userIdStream: Stream.value(null),
            userNameStream: Stream.value(null),
            userEmailStream: Stream.value(null),
            hasPlusSupportUnlockedStream: Stream.value(false),
            isUserInGroupOnboardingStream: Stream.value(false),
            typeOfUserStream: Stream.value(null),
            urlLauncher: urlLauncher,
          );

          // Workaround to wait for stream subscription in constructor.
          await Future.delayed(Duration.zero);

          expect(
            () => controller.getVideoCallAppointmentsUnencodedUrlWithPrefills(),
            throwsA(isA<UserNotAuthenticatedException>()),
          );
        },
      );

      test('returns url with user data', () async {
        final controller = SupportPageController(
          userIdStream: Stream.value(const UserId('userId123')),
          userNameStream: Stream.value('My Cool Name'),
          userEmailStream: Stream.value('my@email.com'),
          hasPlusSupportUnlockedStream: Stream.value(false),
          isUserInGroupOnboardingStream: Stream.value(false),
          typeOfUserStream: Stream.value(null),
          urlLauncher: urlLauncher,
        );

        // Workaround to wait for stream subscription in constructor.
        await Future.delayed(Duration.zero);

        expect(
          controller.getVideoCallAppointmentsUnencodedUrlWithPrefills(),
          'https://sharezone.net/sharezone-plus-video-call-support?userId=userId123&name=My Cool Name&email=my@email.com',
        );
      });
    });

    group('hasPlusSupportUnlocked', () {
      test('show free support for parents', () async {
        final controller = SupportPageController(
          userIdStream: Stream.value(const UserId('userId123')),
          userNameStream: Stream.value('My Cool Name'),
          userEmailStream: Stream.value('my@email.com'),
          hasPlusSupportUnlockedStream: Stream.value(true),
          isUserInGroupOnboardingStream: Stream.value(false),
          typeOfUserStream: Stream.value(TypeOfUser.parent),
          urlLauncher: urlLauncher,
        );

        // Workaround to wait for stream subscription in constructor.
        await Future.delayed(Duration.zero);

        expect(controller.hasPlusSupportUnlocked, false);
      });

      test('show free support for teachers', () async {
        final controller = SupportPageController(
          userIdStream: Stream.value(const UserId('userId123')),
          userNameStream: Stream.value('My Cool Name'),
          userEmailStream: Stream.value('my@email.com'),
          hasPlusSupportUnlockedStream: Stream.value(true),
          isUserInGroupOnboardingStream: Stream.value(false),
          typeOfUserStream: Stream.value(TypeOfUser.teacher),
          urlLauncher: urlLauncher,
        );

        // Workaround to wait for stream subscription in constructor.
        await Future.delayed(Duration.zero);

        expect(controller.hasPlusSupportUnlocked, false);
      });

      test('show free support for students without Sharezone Plus', () async {
        final controller = SupportPageController(
          userIdStream: Stream.value(const UserId('userId123')),
          userNameStream: Stream.value('My Cool Name'),
          userEmailStream: Stream.value('my@email.com'),
          hasPlusSupportUnlockedStream: Stream.value(false),
          isUserInGroupOnboardingStream: Stream.value(false),
          typeOfUserStream: Stream.value(TypeOfUser.teacher),
          urlLauncher: urlLauncher,
        );

        // Workaround to wait for stream subscription in constructor.
        await Future.delayed(Duration.zero);

        expect(controller.hasPlusSupportUnlocked, false);
      });

      test('show plus support for students with Sharezone Plus', () async {
        final controller = SupportPageController(
          userIdStream: Stream.value(const UserId('userId123')),
          userNameStream: Stream.value('My Cool Name'),
          userEmailStream: Stream.value('my@email.com'),
          hasPlusSupportUnlockedStream: Stream.value(true),
          isUserInGroupOnboardingStream: Stream.value(false),
          typeOfUserStream: Stream.value(TypeOfUser.student),
          urlLauncher: urlLauncher,
        );

        // Workaround to wait for stream subscription in constructor.
        await Future.delayed(Duration.zero);

        expect(controller.hasPlusSupportUnlocked, true);
      });
    });

    group('open email app', () {
      test('free user', () async {
        final controller = SupportPageController(
          userIdStream: Stream.value(const UserId('userId123')),
          userNameStream: Stream.value('My Cool Name'),
          userEmailStream: Stream.value('my@email.com'),
          hasPlusSupportUnlockedStream: Stream.value(false),
          isUserInGroupOnboardingStream: Stream.value(false),
          typeOfUserStream: Stream.value(TypeOfUser.student),
          urlLauncher: urlLauncher,
        );

        // Workaround to wait for stream subscription in constructor.
        await Future.delayed(Duration.zero);

        await controller.sendEmailToFreeSupport();

        verify(
          urlLauncher.tryLaunchMailOrThrow(
            freeSupportEmail,
            subject: "Meine Anfrage [User-ID: userId123]",
          ),
        );
      });

      test('plus user', () async {
        final controller = SupportPageController(
          userIdStream: Stream.value(const UserId('userId123')),
          userNameStream: Stream.value('My Cool Name'),
          userEmailStream: Stream.value('my@email.com'),
          hasPlusSupportUnlockedStream: Stream.value(true),
          isUserInGroupOnboardingStream: Stream.value(false),
          typeOfUserStream: Stream.value(TypeOfUser.student),
          urlLauncher: urlLauncher,
        );

        // Workaround to wait for stream subscription in constructor.
        await Future.delayed(Duration.zero);

        await controller.sendEmailToPlusSupport();

        verify(
          urlLauncher.tryLaunchMailOrThrow(
            plusSupportEmail,
            subject: "[💎 Plus Support] Meine Anfrage [User-ID: userId123]",
          ),
        );
      });
    });
  });
}
