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
import 'package:platform_check/platform_check.dart';
import 'package:sharezone/sharezone_plus/subscription_service/is_buying_enabled.dart';
import 'package:sharezone/sharezone_plus/subscription_service/purchase_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/revenue_cat_sharezone_plus_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:stripe_checkout_session/stripe_checkout_session.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/user.dart';

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

  late BuyingFlagApi _buyingFlagApi;

  StreamSubscription<bool>? _hasPlusSubscription;

  SharezonePlusPageController({
    required RevenueCatPurchaseService purchaseService,
    required SubscriptionService subscriptionService,
    required StripeCheckoutSession stripeCheckoutSession,
    required UserId userId,
    required BuyingFlagApi buyingFlagApi,
  }) {
    _purchaseService = purchaseService;
    _subscriptionService = subscriptionService;
    _stripeCheckoutSession = stripeCheckoutSession;
    _userId = userId;
    hasPlus = subscriptionService.isSubscriptionActive();
    _buyingFlagApi = buyingFlagApi;
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
    } else {
      await _purchaseService
          .purchase(ProductId('default-dev-plus-subscription'));
    }

    hasPlus = true;
    notifyListeners();
  }

  Future<bool> isBuyingEnabled() async {
    final flag = await _buyingFlagApi.isBuyingEnabled();

    return switch (flag) {
      BuyingFlag.enabled => true,
      BuyingFlag.disabled => false,
      BuyingFlag.unknown => throw const CouldNotDetermineIsBuyingEnabled(),
    };
  }

  Future<void> _buyOnWeb() async {
    // The URL is used to redirect the user back to the web app after the
    // payment is completed or canceled.
    final webAppUrl = Uri.base;

    final checkoutUrl = await _stripeCheckoutSession.create(
      userId: '$_userId',
      // Since we can't navigate with URLs on the web, we have to use the
      // success and cancel URLs to redirect the user back to the web app.
      //
      // Ticket: https://github.com/SharezoneApp/sharezone-app/issues/971
      successUrl: webAppUrl,
      cancelUrl: webAppUrl,
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
    final source = _subscriptionService.getSource();
    if (source == null) {
      throw StateError(
          '$SubscriptionSource was null, can not cancel subscription.');
    }

    if (!canCancelSubscription(source)) {
      throw CanNotCancelOnThisPlatform(source);
    }

    if (PlatformCheck.isWeb) {
      // ...
    } else {
      final managementUrl = await _purchaseService.getManagementUrl();
      if (managementUrl != null) {
        await launchUrl(Uri.parse(managementUrl));
      } else {
        throw const CouldNotGetManagementUrl();
      }
    }
  }

  bool canCancelSubscription(SubscriptionSource source) {
    return switch (source) {
      SubscriptionSource.appStore => PlatformCheck.isIOS,
      SubscriptionSource.playStore => PlatformCheck.isAndroid,
      SubscriptionSource.stripe => true,
      SubscriptionSource.unknown => false,
    };
  }

  @override
  void dispose() {
    _hasPlusSubscription?.cancel();
    super.dispose();
  }
}

class CanNotCancelOnThisPlatform implements Exception {
  final SubscriptionSource? source;

  const CanNotCancelOnThisPlatform(this.source);
}

class CouldNotGetManagementUrl implements Exception {
  const CouldNotGetManagementUrl();
}

class CouldNotDetermineIsBuyingEnabled implements Exception {
  const CouldNotDetermineIsBuyingEnabled();
}
