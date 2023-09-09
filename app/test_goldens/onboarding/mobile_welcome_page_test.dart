// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:sharezone/onboarding/mobile_welcome_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

void main() {
  group(MobileWelcomePage, () {
    Future<void> _pumpPage(WidgetTester tester, {ThemeData? theme}) async {
      await tester.pumpWidgetBuilder(
        MobileWelcomePage(),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    testGoldens('renders as expected (light theme)', (tester) async {
      await _pumpPage(tester, theme: lightTheme);

      await multiScreenGolden(tester, 'mobile_welcome_page_light');
    });

    // At the moment, the screen is hard coded to dark mode. This test will just
    // ensures that the screen is still rendered with the correct colors.
    //
    // Ticket: https://github.com/SharezoneApp/sharezone-app/issues/916
    testGoldens('renders as expected (dark theme)', (tester) async {
      await _pumpPage(tester, theme: darkTheme);

      await multiScreenGolden(tester, 'mobile_welcome_page_dark');
    });
  });
}
