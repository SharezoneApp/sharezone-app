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
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

class MockSharezonePlusPageController extends ChangeNotifier
    implements SharezonePlusPageController {
  @override
  bool? hasPlus;

  @override
  String? monthlySubscriptionPrice;

  bool buySubscriptionCalled = false;
  @override
  Future<void> buy() async {
    buySubscriptionCalled = true;
  }

  bool cancelSubscriptionCalled = false;
  @override
  Future<void> cancelSubscription() async {
    cancelSubscriptionCalled = true;
  }

  @override
  bool canCancelSubscription(SubscriptionSource source) {
    return true;
  }

  @override
  Future<bool> isBuyingEnabled() async {
    return true;
  }

  @override
  bool isPurchaseButtonLoading = false;

  @override
  String? lifetimePrice;

  @override
  void setPeriodOption(PurchasePeriod period) {}

  @override
  PurchasePeriod selectedPurchasePeriod = PurchasePeriod.monthly;

  bool _isCancelled = false;
  @override
  bool get isCancelled => _isCancelled;

  void setIsCancelled(bool isCancelled) {
    _isCancelled = isCancelled;
    notifyListeners();
  }

  @override
  void listenToStatus() {}

  @override
  bool get hasLifetime => false;

  @override
  void logOpenGitHub() {}

  @override
  void logOpenedAdvantage(String advantage) {}

  @override
  void logOpenedFaq(String question) {}
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

    testWidgets('if loading then $GrayShimmer is shown', (tester) async {
      controller.hasPlus = null;
      controller.monthlySubscriptionPrice = null;
      controller.lifetimePrice = null;

      await pumpPlusPage(tester);
      await tester.ensureVisible(find.byType(CallToActionButton));

      expect(find.byType(GrayShimmer), findsWidgets);
    });

    testWidgets('if loading then the "subscribe" button is disabled',
        (tester) async {
      controller.hasPlus = null;
      controller.monthlySubscriptionPrice = null;
      controller.lifetimePrice = null;
      controller.isPurchaseButtonLoading = true;

      await pumpPlusPage(tester);
      await tester.ensureVisible(find.byType(CallToActionButton));
      await tester.tap(find.byType(CallToActionButton), warnIfMissed: false);

      expect(controller.buySubscriptionCalled, false);
      expect(controller.cancelSubscriptionCalled, false);
      expect(
          tester
              .widget<BuySection>(find.byType(BuySection))
              .isPurchaseButtonLoading,
          true);
    });

    testWidgets('calls cancelSubscription() when "cancel" is pressed',
        (tester) async {
      controller.hasPlus = true;
      controller.monthlySubscriptionPrice = '4,99 €';
      controller.lifetimePrice = '19,99 €';

      await pumpPlusPage(tester);
      await tester.ensureVisible(find.byType(CallToActionButton));
      await tester.tap(find.widgetWithText(CallToActionButton, 'Kündigen'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Kündigen'));

      expect(controller.cancelSubscriptionCalled, true);
    });

    testWidgets('calls buySubscription() when "subscribe" is pressed',
        (tester) async {
      controller.hasPlus = false;
      controller.monthlySubscriptionPrice = '4,99 €';
      controller.lifetimePrice = '19,99 €';

      await pumpPlusPage(tester);
      await tester.ensureVisible(find.byType(CallToActionButton));
      await tester.tap(find.widgetWithText(CallToActionButton, 'Abonnieren'));

      expect(controller.buySubscriptionCalled, true);
    });

    testWidgets('shows price to pay if not subscribed', (tester) async {
      controller.hasPlus = false;
      controller.monthlySubscriptionPrice = '4,99 €';
      controller.lifetimePrice = '19,99 €';

      await pumpPlusPage(tester);

      expect(find.text('4,99 €'), findsOneWidget);
    });

    testWidgets('shows "cancel" button if subscribed', (tester) async {
      controller.hasPlus = true;
      controller.monthlySubscriptionPrice = '4,99 €';
      controller.lifetimePrice = '19,99 €';

      await pumpPlusPage(tester);

      expect(
          find.widgetWithText(CallToActionButton, 'Kündigen'), findsOneWidget);
    });
  });
}
