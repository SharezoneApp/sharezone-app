// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/sharezone_plus/subscription_service/revenue_cat_sharezone_plus_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:stripe_checkout_session/stripe_checkout_session.dart';
import 'package:url_launcher/url_launcher.dart';

/// A fallback price if the price cannot be fetched from the backend.
///
/// On macOS the price is not fetched from the backend because RevenueCat does
/// not support macOS.
const fallbackPlusPrice = '4,99 €';

class SharezonePlusPageController extends ChangeNotifier {
  // ignore: unused_field
  late RevenueCatPurchaseService _purchaseService;
  // ignore: unused_field
  late SubscriptionService _subscriptionService;

  late StripeCheckoutSession _stripeCheckoutSession;
  late UserId _userId;

  StreamSubscription<bool>? _hasPlusSubscription;

  SharezonePlusPageController({
    required RevenueCatPurchaseService purchaseService,
    required SubscriptionService subscriptionService,
    required StripeCheckoutSession stripeCheckoutSession,
    required UserId userId,
  }) {
    _purchaseService = purchaseService;
    _subscriptionService = subscriptionService;
    _stripeCheckoutSession = stripeCheckoutSession;
    _userId = userId;

    // Fake loading for development purposes.
    Future.delayed(const Duration(seconds: 1)).then((value) {
      hasPlus = false;
      price = fallbackPlusPrice;
      notifyListeners();
    });
  }

  /// Whether the user has a Sharezone Plus subscription.
  ///
  /// If `null` then the status is still loading.
  bool? hasPlus;

  /// The price for the Sharezone Plus per month, including the currency sign.
  ///
  /// If the user is subscribed to Sharezone Plus then this is the price for
  /// his current subscription.
  ///
  /// If the user is not subscribed to Sharezone Plus then this is the price
  /// for a new subscription.
  ///
  /// If `null` then the price is still loading.
  String? price;

  Future<void> buySubscription() async {
    if (PlatformCheck.isWeb) {
      await _buyOnWeb();
    }

    hasPlus = true;
    notifyListeners();
  }

  Future<void> _buyOnWeb() async {
    final checkoutUrl = await _stripeCheckoutSession.create(
      userId: '$_userId',
    );

    await launchUrl(
      Uri.parse(checkoutUrl),
      // Since the request for creating the checkout session is asynchronous, we
      // can't open the checkout in a new tab due to the browser security
      // policy.
      //
      // See https://github.com/flutter/flutter/issues/78524.
      webOnlyWindowName: "_self",
    );
  }

  Future<void> cancelSubscription() async {
    hasPlus = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _hasPlusSubscription?.cancel();
    super.dispose();
  }
}
