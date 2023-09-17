// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_flag.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone/support/support_page_controller.dart';

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
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SupportPageController>.value(
                value: controller),
            ChangeNotifierProvider<SubscriptionEnabledFlag>.value(
                value: subscriptionEnabledFlag),
          ],
          child: const MaterialApp(
            home: SupportPage(),
          ),
        ),
      );
    }

    testWidgets('shows plus support section when user has plus',
        (tester) async {
      when(controller.hasPlusSupportUnlocked).thenReturn(true);

      await pumpSupportPage(tester);

      expect(find.byKey(const ValueKey('plus-support')), findsOneWidget);
    });

    testWidgets('does not show free support section when user has plus',
        (tester) async {
      when(controller.hasPlusSupportUnlocked).thenReturn(true);
      await pumpSupportPage(tester);

      expect(find.byKey(const ValueKey('free-support')), findsNothing);
    });

    testWidgets('does not show plus support section when user has no plus',
        (tester) async {
      when(controller.hasPlusSupportUnlocked).thenReturn(false);

      await pumpSupportPage(tester);

      expect(find.byKey(const ValueKey('plus-support')), findsNothing);
    });

    testWidgets('shows free support section when user has no plus',
        (tester) async {
      when(controller.hasPlusSupportUnlocked).thenReturn(false);

      await pumpSupportPage(tester);

      expect(find.byKey(const ValueKey('free-support')), findsOneWidget);
    });

    testWidgets(
        'does show plus advertising when user is not in group onboarding',
        (tester) async {
      when(controller.hasPlusSupportUnlocked).thenReturn(false);
      when(controller.isUserInGroupOnboarding).thenReturn(false);

      await pumpSupportPage(tester);

      expect(find.byKey(const ValueKey('sharezone-plus-advertising')),
          findsOneWidget);
    });

    testWidgets(
        'does not show plus advertising when user is in group onboarding',
        (tester) async {
      when(controller.hasPlusSupportUnlocked).thenReturn(false);
      when(controller.isUserInGroupOnboarding).thenReturn(true);

      await pumpSupportPage(tester);

      expect(find.byKey(const ValueKey('sharezone-plus-advertising')),
          findsNothing);
    });
  });
}
