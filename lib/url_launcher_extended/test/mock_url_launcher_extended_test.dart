// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:test/test.dart';
import 'package:url_launcher_extended/mock_url_launcher_extended.dart';

import '../lib/url_launcher_extended.dart';

void main() {
  group('MockUrlLauncherExtended', () {
    MockUrlLauncherExtended mockUrlLauncherExtended;

    setUp(() {
      mockUrlLauncherExtended = MockUrlLauncherExtended();
    });

    test('.canLaunch returns true as default.', () async {
      final canLaunch = await mockUrlLauncherExtended.canLaunch("urlString");
      expect(canLaunch, true);
    });

    test('.canLaunch returns the set value.', () async {
      mockUrlLauncherExtended.setCanLaunch(false);
      final canLaunch = await mockUrlLauncherExtended.canLaunch("urlString");
      expect(canLaunch, false);
    });

    test('.launch logs call', () async {
      // Before method call the logged attribute should return false.
      expect(mockUrlLauncherExtended.logCalledLaunch, false);

      await mockUrlLauncherExtended.launch("urlString");

      expect(mockUrlLauncherExtended.logCalledLaunch, true);
    });

    test('.launchMail logs call', () async {
      // Before method call the logged attribute should return false.
      expect(mockUrlLauncherExtended.logCalledLaunchMail, false);

      await mockUrlLauncherExtended.tryLaunchMailOrThrow("test@sharezone.net");

      expect(mockUrlLauncherExtended.logCalledLaunchMail, true);
    });

    test('.tryLaunchOrThrow launches link if it can', () async {
      // .canLaunch is already true
      final result =
          await mockUrlLauncherExtended.tryLaunchOrThrow("urlString");
      expect(result, true);
    });

    test('.tryLaunchOrThrow throws exception if link can not be launch',
        () async {
      mockUrlLauncherExtended.setCanLaunch(false);

      try {
        await mockUrlLauncherExtended.tryLaunchOrThrow("urlString");
      } on Exception catch (e) {
        expect(e, CouldNotLaunchUrlException("urlString"));
      }
    });
  });
}
