// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:remote_configuration/remote_configuration.dart';
import 'package:sharezone/sharezone_plus/sharezone_plus_fallback_price.dart';
import 'package:sharezone/sharezone_plus/subscription_service/purchase_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/revenue_cat_sharezone_plus_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';

class SharezonePlusPageController extends ChangeNotifier {
  late PurchaseService _purchaseService;
  late SubscriptionService _subscriptionService;
  late RemoteConfiguration _remoteConfiguration;

  StreamSubscription<bool>? _hasPlusSubscription;

  SharezonePlusPageController({
    required PurchaseService purchaseService,
    required SubscriptionService subscriptionService,
    required RemoteConfiguration remoteConfiguration,
  }) {
    _purchaseService = purchaseService;
    _subscriptionService = subscriptionService;
    _remoteConfiguration = remoteConfiguration;

    _getFallbackPrice();
    _listenToPlusStatus();
    _getPlusPrice();
  }

  void _getFallbackPrice() {
    try {
      final res = _remoteConfiguration.getString('sz_plus_price_with_symbol');
      // Remote config returns an empty string if the key is not found.
      if (res.isNotEmpty) {
        price = res;
        return;
      } else {
        log('Could not find Sharezone Plus price in remote config. Using hardcoded fallback price: $fallbackSharezonePlusPriceWithCurrencySymbol.');
      }
    } catch (e, s) {
      log('Error when fetching Sharezone Plus price from remote config. Using hardcoded fallback price: $fallbackSharezonePlusPriceWithCurrencySymbol.',
          error: e, stackTrace: s);
    }
    price = fallbackSharezonePlusPriceWithCurrencySymbol;
  }

  /// Whether the user has a Sharezone Plus subscription.
  ///
  /// We use `false` as the initial value because we don't know if the user has
  /// a subscription or not. The value will be updated as soon as the
  /// subscription status is fetched from the backend.
  bool hasPlus = false;

  /// The price of the Sharezone Plus subscription including the currency
  /// symbol.
  late String price;

  Future<void> _getPlusPrice() async {
    StoreProduct? product;

    // We have already set the price to the fallback price in the constructor.
    // So should this fail then the fallback price will be used instead.
    try {
      product = await getPlusSubscriptionProduct();
    } catch (e, s) {
      log('Could not fetch Sharezone Plus price from the backend.',
          error: e, stackTrace: s);
    }

    if (product != null) {
      price = product.priceString;
      notifyListeners();
    }
  }

  Future<StoreProduct?> getPlusSubscriptionProduct() async {
    return (await _purchaseService.getProducts()).firstOrNull;
  }

  void _listenToPlusStatus() {
    final hasPlus = _subscriptionService.isSubscriptionActiveStream();

    _hasPlusSubscription = hasPlus.listen((hasPlus) {
      this.hasPlus = hasPlus;
      notifyListeners();
    });
  }

  Future<void> buySubscription() async {
    // Implement
    final purchaseService = RevenueCatPurchaseService();
    final products = await purchaseService.getProducts();
    print(products);

    await purchaseService.purchase(ProductId('default-dev-plus-subscription'));
  }

  Future<void> cancelSubscription() async {
    // Implement
  }

  @override
  void dispose() {
    _hasPlusSubscription?.cancel();
    super.dispose();
  }
}
