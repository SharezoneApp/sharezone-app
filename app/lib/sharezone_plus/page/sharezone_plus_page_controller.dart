// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sharezone/sharezone_plus/subscription_service/purchase_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/revenue_cat_sharezone_plus_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';

/// A fallback price if the price cannot be fetched from the backend.
///
/// On macOS the price is not fetched from the backend because RevenueCat does
/// not support macOS.
const fallbackPlusPrice = '4,99 €';

class SharezonePlusPageController extends ChangeNotifier {
  late RevenueCatPurchaseService _purchaseService;
  late SubscriptionService _subscriptionService;

  StreamSubscription<bool>? _hasPlusSubscription;

  SharezonePlusPageController({
    required RevenueCatPurchaseService purchaseService,
    required SubscriptionService subscriptionService,
  }) {
    _purchaseService = purchaseService;
    _subscriptionService = subscriptionService;

    _listenToPlusStatus();
    _getPlusPrice();
  }

  /// Whether the user has a Sharezone Plus subscription.
  ///
  /// We use `false` as the initial value because we don't know if the user has
  /// a subscription or not. The value will be updated as soon as the
  /// subscription status is fetched from the backend.
  bool hasPlus = false;

  /// The price of the Sharezone Plus subscription including the currency
  /// symbol.
  String price = fallbackPlusPrice;

  Future<void> _getPlusPrice() async {
    final product = await _purchaseService.getPlusSubscriptionProduct();

    if (product != null) {
      price = product.priceString;
      notifyListeners();
    }
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
