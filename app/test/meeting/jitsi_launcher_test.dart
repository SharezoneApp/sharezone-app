// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/meeting/jitsi/jitsi_launcher.dart';
import 'package:url_launcher_extended/mock_url_launcher_extended.dart';

void main() {
  group('JitsiLauncher', () {
    JitsiLauncher jitsi;
    MockUrlLauncherExtended urlLauncherExtended;

    const serverUrl = "https://mock.meet.sharezone.net";

    setUp(() {
      urlLauncherExtended = MockUrlLauncherExtended();
      jitsi = JitsiLauncher(serverUrl, urlLauncherExtended);
    });

    test('.getMeetingUrl returns valid meeting url', () {
      const meetingId = "c8yu-lj4g-7s99";
      const jwt = "1289sdfh2";

      final url = jitsi.getMeetingUrl(meetingId, jwt);
      expect(url, "$serverUrl/$meetingId?jwt=$jwt");
    });

    test('.openBrowserMeeting opens meeting url', () async {
      const meetingId = "c8yu-lj4g-7s99";
      const jwt = "1289sdfh2";

      expect(urlLauncherExtended.logCalledLaunch, false);
      expect(urlLauncherExtended.launchedUrl, null);

      await jitsi.joinBrowserMeeting(meetingId: meetingId, jwt: jwt);

      expect(urlLauncherExtended.logCalledLaunch, true);
      expect(
        urlLauncherExtended.launchedUrl,
        jitsi.getMeetingUrl(meetingId, jwt),
      );
    });
  });
}
