// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_controller.dart';

class MockSharezonePlusPageController extends ChangeNotifier
    implements SharezonePlusPageController {
  @override
  bool? hasPlus;

  @override
  String? price;

  bool buySubscriptionCalled = false;
  @override
  Future<void> buySubscription() async {
    buySubscriptionCalled = true;
  }

  bool cancelSubscriptionCalled = false;
  @override
  Future<void> cancelSubscription() async {
    cancelSubscriptionCalled = true;
  }
}

void main() {
  group(SharezonePlusPage, () {
    late MockSharezonePlusPageController controller;

    setUp(() {
      controller = MockSharezonePlusPageController();
    });

    Future<void> pumpPlusPage(WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<SharezonePlusPageController>(
          create: (context) => controller,
          child:
              const MaterialApp(home: Scaffold(body: SharezonePlusPageMain())),
        ),
      );
    }

    testWidgets(
        'shows $PriceLoadingIndicator if plus status has loaded but the price hasnt',
        (tester) async {
      controller.hasPlus = true;
      controller.price = null;

      await pumpPlusPage(tester);
      await tester.ensureVisible(find.byType(CallToActionButton));

      expect(find.byType(PriceLoadingIndicator), findsOneWidget);
    });

    testWidgets('if loading then the $PriceLoadingIndicator is shown',
        (tester) async {
      controller.hasPlus = null;
      controller.price = null;

      await pumpPlusPage(tester);
      await tester.ensureVisible(find.byType(CallToActionButton));

      expect(find.byType(PriceLoadingIndicator), findsOneWidget);
    });

    testWidgets('if loading then the "subscribe" button is disabled',
        (tester) async {
      controller.hasPlus = null;
      controller.price = null;

      await pumpPlusPage(tester);
      await tester.ensureVisible(find.byType(CallToActionButton));
      await tester.tap(find.byType(CallToActionButton), warnIfMissed: false);

      expect(controller.buySubscriptionCalled, false);
      expect(controller.cancelSubscriptionCalled, false);
      expect(
          tester
              .widget<CallToActionButton>(find.byType(CallToActionButton))
              .onPressed,
          null);
    });

    testWidgets('calls cancelSubscription() when "cancel" is pressed',
        (tester) async {
      controller.hasPlus = true;
      controller.price = '4,99 €';

      await pumpPlusPage(tester);
      await tester.ensureVisible(find.byType(CallToActionButton));
      await tester.tap(find.widgetWithText(CallToActionButton, 'Kündigen'));

      expect(controller.cancelSubscriptionCalled, true);
    });

    testWidgets('calls buySubscription() when "subscribe" is pressed',
        (tester) async {
      controller.hasPlus = false;
      controller.price = '4,99 €';

      await pumpPlusPage(tester);
      await tester.ensureVisible(find.byType(CallToActionButton));
      await tester.tap(find.widgetWithText(CallToActionButton, 'Abonnieren'));

      expect(controller.buySubscriptionCalled, true);
    });

    testWidgets('shows price to pay if not subscribed', (tester) async {
      controller.hasPlus = false;
      controller.price = '4,99 €';

      await pumpPlusPage(tester);

      expect(find.text('4,99 €'), findsOneWidget);
    });

    testWidgets('shows currently paid price if subscribed', (tester) async {
      controller.hasPlus = true;
      controller.price = '4,99 €';

      await pumpPlusPage(tester);

      expect(find.text('4,99 €'), findsOneWidget);
    });

    testWidgets('shows "subscribe" button if not subscribed', (tester) async {
      controller.hasPlus = false;
      controller.price = '4,99 €';

      await pumpPlusPage(tester);

      expect(find.widgetWithText(CallToActionButton, 'Abonnieren'),
          findsOneWidget);
    });

    testWidgets('shows "cancel" button if subscribed', (tester) async {
      controller.hasPlus = true;
      controller.price = '4,99 €';

      await pumpPlusPage(tester);

      expect(
          find.widgetWithText(CallToActionButton, 'Kündigen'), findsOneWidget);
    });
  });
}
