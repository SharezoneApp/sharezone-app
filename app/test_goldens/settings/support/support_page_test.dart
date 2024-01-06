// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_flag.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone/support/support_page_controller.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'support_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SupportPageController>(),
  MockSpec<SubscriptionEnabledFlag>(),
])
void main() {
  group(SupportPage, () {
    late MockSupportPageController controller;
    late MockSubscriptionEnabledFlag subscriptionEnabledFlag;

    setUp(() {
      controller = MockSupportPageController();
      subscriptionEnabledFlag = MockSubscriptionEnabledFlag();

      when(controller.isUserSignedIn).thenReturn(true);
      when(subscriptionEnabledFlag.isEnabled).thenReturn(true);
    });

    Future<void> pumpSupportPage(
      WidgetTester tester, {
      ThemeData? theme,
    }) async {
      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SupportPageController>.value(
                value: controller),
            ChangeNotifierProvider<SubscriptionEnabledFlag>.value(
                value: subscriptionEnabledFlag),
          ],
          child: const SupportPage(),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    group('with Sharezone Plus', () {
      setUp(() {
        when(controller.hasPlusSupportUnlocked).thenReturn(true);
      });

      testGoldens('renders as expected (light mode)', (tester) async {
        await pumpSupportPage(tester, theme: getLightTheme());

        await multiScreenGolden(tester, 'support_page_with_plus_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        await pumpSupportPage(tester, theme: getDarkTheme());

        await multiScreenGolden(tester, 'support_page_with_plus_dark');
      });
    });

    group('without Sharezone Plus', () {
      setUp(() {
        when(controller.hasPlusSupportUnlocked).thenReturn(false);
      });

      testGoldens('renders as expected (light mode)', (tester) async {
        await pumpSupportPage(tester, theme: getLightTheme());

        await multiScreenGolden(tester, 'support_page_without_plus_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        await pumpSupportPage(tester, theme: getDarkTheme());

        await multiScreenGolden(tester, 'support_page_without_plus_dark');
      });
    });
  });
}
