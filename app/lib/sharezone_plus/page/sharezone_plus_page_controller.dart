// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:common_domain_models/common_domain_models.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform_check/platform_check.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page_analytics.dart';
import 'package:sharezone/sharezone_plus/subscription_service/is_buying_enabled.dart';
import 'package:sharezone/sharezone_plus/subscription_service/purchase_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/revenue_cat_sharezone_plus_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
import 'package:stripe_checkout_session/stripe_checkout_session.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/user.dart';

const fallbackPlusMonthlyPrice = '1,99 €';
const fallbackPlusLifetimePrice = '19,99 €';

class SharezonePlusPageController extends ChangeNotifier {
  late RevenueCatPurchaseService _purchaseService;
  late SubscriptionService _subscriptionService;
  late CrashAnalytics _crashAnalytics;
  late StripeCheckoutSession _stripeCheckoutSession;
  late UserId _userId;
  late BuyingEnabledApi _buyingFlagApi;
  late SharezonePlusPageAnalytics _analytics;

  StreamSubscription<bool>? _hasPlusSubscription;
  StreamSubscription<SharezonePlusStatus?>? _sharezonePlusStatusSubscription;

  SharezonePlusPageController({
    required RevenueCatPurchaseService purchaseService,
    required SubscriptionService subscriptionService,
    required StripeCheckoutSession stripeCheckoutSession,
    required CrashAnalytics crashAnalytics,
    required UserId userId,
    required BuyingEnabledApi buyingFlagApi,
    required SharezonePlusPageAnalytics analytics,
  }) {
    _purchaseService = purchaseService;
    _subscriptionService = subscriptionService;
    _stripeCheckoutSession = stripeCheckoutSession;
    _userId = userId;
    monthlySubscriptionPrice = fallbackPlusMonthlyPrice;
    lifetimePrice = fallbackPlusLifetimePrice;
    _buyingFlagApi = buyingFlagApi;
    _crashAnalytics = crashAnalytics;
    _analytics = analytics;

    listenToStatus();
  }

  void listenToStatus() {
    final statusStream = _subscriptionService.sharezonePlusStatusStream;
    _sharezonePlusStatusSubscription = statusStream.listen((status) {
      if (_status != status) {
        _status = status;

        // The loading is started when buy process starts and stopped when the
        // status is updated. Therefore, the loading is still displayed even if
        // our payment provider (like RevenueCat) has already processed the
        // payment but the status is not yet updated in the database.
        isPurchaseButtonLoading = false;

        notifyListeners();
      }
    });
  }

  SharezonePlusStatus? _status;

  /// Whether the user has a Sharezone Plus subscription.
  ///
  /// If `null` then the status is still loading.
  bool? get hasPlus => _status?.hasPlus;

  /// Whether the user has a Sharezone Plus subscription that is cancelled.
  bool get isCancelled => _status?.isCancelled ?? false;

  /// Whether the user has a Sharezone Plus subscription that has a lifetime
  /// period.
  bool get hasLifetime => _status?.hasLifetime ?? false;

  /// The price for the Sharezone Plus per month, including the currency sign.
  ///
  /// If the user is subscribed to Sharezone Plus then this is the price for
  /// his current subscription.
  ///
  /// If the user is not subscribed to Sharezone Plus then this is the price
  /// for a new subscription.
  ///
  /// If `null` then the price is still loading.
  String? monthlySubscriptionPrice;

  /// The price for the Sharezone Plus lifetime purchase, including the currency
  /// sign.
  String? lifetimePrice;

  /// Whether the purchase button is currently loading.
  ///
  /// This is used to show a loading indicator on the purchase button while the
  /// purchase is in progress.
  bool isPurchaseButtonLoading = false;

  /// The purchase option that the user has selected.
  PurchasePeriod selectedPurchasePeriod = PurchasePeriod.monthly;

  Future<void> buy() async {
    try {
      _analytics.logSubscribed(
        selectedPurchasePeriod.name,
        PlatformCheck.currentPlatform.name,
      );

      if (PlatformCheck.isWeb) {
        await _buyOnWeb();
      } else {
        await _purchaseService.purchase(_getProductId());
      }
    } catch (e, s) {
      isPurchaseButtonLoading = false;
      notifyListeners();

      if ('$e'.contains('PURCHASE_CANCELLED')) {
        // User aborted the purchase.
        return;
      }

      _crashAnalytics.recordError('Error when buying Sharezone Plus: $e', s);
      rethrow;
    }
  }

  ProductId _getProductId() {
    final platform = PlatformCheck.currentPlatform;
    return switch (selectedPurchasePeriod) {
      PurchasePeriod.lifetime => switch (platform) {
          Platform.android => const ProductId('sz_plus_lifetime_play_store'),
          Platform.iOS ||
          Platform.macOS =>
            const ProductId('sz_plus_lifetime_app_store'),
          _ => throw UnsupportedError('Platform $platform is not supported.'),
        },
      PurchasePeriod.monthly => switch (platform) {
          Platform.android =>
            const ProductId('sz_plus_subscription_play_store:monthly'),
          Platform.iOS ||
          Platform.macOS =>
            const ProductId('sz_plus_subscription_monthly_app_store'),
          _ => throw UnsupportedError('Platform $platform is not supported.'),
        },
    };
  }

  Future<bool> isBuyingEnabled() async {
    isPurchaseButtonLoading = true;
    notifyListeners();

    final flag = await _buyingFlagApi.isBuyingEnabled();

    return switch (flag) {
      BuyingFlag.enabled => true,
      BuyingFlag.disabled => false,
      BuyingFlag.unknown =>
        throw const CouldNotDetermineIsBuyingEnabledException(),
    };
  }

  Future<void> _buyOnWeb() async {
    // The URL is used to redirect the user back to the web app after the
    // payment is completed or canceled.
    final webAppUrl = switch (PlatformCheck.currentPlatform) {
      Platform.web => Uri.base,
      _ => Uri.parse('https://web.sharezone.net'),
    };

    final checkoutUrl = await _stripeCheckoutSession.create(
      userId: '$_userId',
      // Since we can't navigate with URLs on the web, we have to use the
      // success and cancel URLs to redirect the user back to the web app.
      //
      // Ticket: https://github.com/SharezoneApp/sharezone-app/issues/971
      successUrl: webAppUrl,
      cancelUrl: webAppUrl,
      period: selectedPurchasePeriod.name,
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
    try {
      _analytics.logCancelledSubscription();
      final source = _subscriptionService.getSource();
      if (source == null) {
        throw StateError(
            '$SubscriptionSource was null, can not cancel subscription.');
      }

      if (!canCancelSubscription(source)) {
        throw CanNotCancelOnThisPlatformException(source);
      }

      if (source == SubscriptionSource.stripe) {
        await _cancelStripeSubscription();
      } else {
        final managementUrl = await _purchaseService.getManagementUrl();
        if (managementUrl != null) {
          await launchUrl(Uri.parse(managementUrl));
        } else {
          throw const CouldNotGetManagementUrlException();
        }
      }
    } catch (e, s) {
      _crashAnalytics.recordError('Error when canceling Sharezone Plus: $e', s);
      rethrow;
    }
  }

  Future<void> _cancelStripeSubscription() async {
    await _subscriptionService.cancelStripeSubscription();
  }

  bool canCancelSubscription(SubscriptionSource source) {
    return switch (source) {
      SubscriptionSource.appStore => PlatformCheck.isIOS,
      SubscriptionSource.playStore => PlatformCheck.isAndroid,
      SubscriptionSource.stripe => true,
      SubscriptionSource.unknown => false,
    };
  }

  void setPeriodOption(PurchasePeriod period) {
    selectedPurchasePeriod = period;
    notifyListeners();
  }

  void logOpenedAdvantage(String advantage) {
    _analytics.logOpenedAdvantage(advantage);
  }

  void logOpenedFaq(String question) {
    _analytics.logOpenedFaq(question);
  }

  void logOpenGitHub() {
    _analytics.logOpenGitHub();
  }

  @override
  void dispose() {
    _hasPlusSubscription?.cancel();
    _sharezonePlusStatusSubscription?.cancel();
    super.dispose();
  }
}

class CanNotCancelOnThisPlatformException implements Exception {
  final SubscriptionSource? source;

  const CanNotCancelOnThisPlatformException(this.source);
}

class CouldNotGetManagementUrlException implements Exception {
  const CouldNotGetManagementUrlException();
}

class CouldNotDetermineIsBuyingEnabledException implements Exception {
  const CouldNotDetermineIsBuyingEnabledException();
}
