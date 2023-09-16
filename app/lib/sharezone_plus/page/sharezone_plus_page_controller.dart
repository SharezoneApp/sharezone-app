// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sharezone/sharezone_plus/subscription_service/purchase_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/revenue_cat_sharezone_plus_service.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';

part 'sharezone_plus_page_controller.g.dart';

/// A fallback price if the price cannot be fetched from the backend.
///
/// On macOS the price is not fetched from the backend because RevenueCat does
/// not support macOS.
const fallbackPlusPrice = '4,99 €';

sealed class PlusPageViewModel {}

class PlusPageLoading extends PlusPageViewModel {}

class PlusPageError extends PlusPageViewModel {
  final dynamic error;
  final StackTrace stackTrace;

  PlusPageError({required this.error, required this.stackTrace});
}

class PlusPageSuccess extends PlusPageViewModel {
  final bool hasPlus;

  /// Formatted price of the item, including its currency sign.
  final String monthlyPriceString;

  /// Whether the subscription can be managed (subscribe, cancel) by the user.
  final bool isSubscriptionManageable;

  PlusPageSuccess({
    required this.hasPlus,
    required this.monthlyPriceString,
    required this.isSubscriptionManageable,
  });
}

sealed class PlusPageEvent {}

class PlusPageBuySubscription extends PlusPageEvent {}

class PlusPageCancelSubscription extends PlusPageEvent {}

class _PlusStatusChanged extends PlusPageEvent {
  final bool hasPlus;

  _PlusStatusChanged({required this.hasPlus});
}

class SharezonePlusPageBloc extends Bloc<PlusPageEvent, PlusPageViewModel> {
  late RevenueCatPurchaseService _purchaseService;
  late SubscriptionService _subscriptionService;

  SharezonePlusPageBloc({
    required RevenueCatPurchaseService purchaseService,
    required SubscriptionService subscriptionService,
  })  : _purchaseService = purchaseService,
        _subscriptionService = subscriptionService,
        super(PlusPageLoading()) {
    on<PlusPageBuySubscription>((event, emit) {
      emit(PlusPageSuccess(
        hasPlus: true,
        monthlyPriceString: '4,99€',
        isSubscriptionManageable: true,
      ));
    });
    on<PlusPageCancelSubscription>((event, emit) {
      emit(PlusPageSuccess(
        hasPlus: false,
        monthlyPriceString: '4,99€',
        isSubscriptionManageable: true,
      ));
    });
    on<_PlusStatusChanged>((event, emit) {
      emit(PlusPageSuccess(
        hasPlus: event.hasPlus,
        monthlyPriceString: '4,99€',
        isSubscriptionManageable: true,
      ));
    });

    // Fake loading time (for development)
    Future.delayed(const Duration(seconds: 1), () async {
      _subscriptionService.isSubscriptionActiveStream().listen((hasPlus) {
        add(_PlusStatusChanged(hasPlus: hasPlus));
      });
    });
  }
}

@riverpod
class SharezonePlusPageNotifier extends _$SharezonePlusPageNotifier {
  late RevenueCatPurchaseService _purchaseService;
  late SubscriptionService _subscriptionService;

  SharezonePlusPageNotifier() {
    // Fake loading time (for development)
    Future.delayed(const Duration(seconds: 1), () async {
      _subscriptionService.isSubscriptionActiveStream().listen((hasPlus) {
        add(_PlusStatusChanged(hasPlus: hasPlus));
      });
    });
  }

  @override
  PlusPageViewModel build(BuildContext context) {
    _purchaseService = context.read<RevenueCatPurchaseService>();
    _subscriptionService = context.read<SubscriptionService>();
    return PlusPageLoading();
  }

  void add(PlusPageEvent event) {
    state = switch (event) {
      PlusPageBuySubscription() => PlusPageSuccess(
          hasPlus: true,
          monthlyPriceString: '4,99€',
          isSubscriptionManageable: true,
        ),
      PlusPageCancelSubscription() => PlusPageSuccess(
          hasPlus: false,
          monthlyPriceString: '4,99€',
          isSubscriptionManageable: true,
        ),
      _PlusStatusChanged(hasPlus: bool hasPlus) => PlusPageSuccess(
          hasPlus: hasPlus,
          monthlyPriceString: '4,99€',
          isSubscriptionManageable: true,
        ),
    };
  }
}

class SharezonePlusPageController2 extends ChangeNotifier {
  late RevenueCatPurchaseService _purchaseService;
  late SubscriptionService _subscriptionService;

  late PlusPageViewModel state;

  SharezonePlusPageController2({
    required RevenueCatPurchaseService purchaseService,
    required SubscriptionService subscriptionService,
  }) {
    _purchaseService = purchaseService;
    _subscriptionService = subscriptionService;

    state = PlusPageLoading();

    // Fake loading time (for development)
    Future.delayed(const Duration(seconds: 1), () async {
      _subscriptionService.isSubscriptionActiveStream().listen((hasPlus) {
        add(_PlusStatusChanged(hasPlus: hasPlus));
      });
    });
  }

  void add(PlusPageEvent event) {
    state = switch (event) {
      PlusPageBuySubscription() => PlusPageSuccess(
          hasPlus: true,
          monthlyPriceString: '4,99€',
          isSubscriptionManageable: true,
        ),
      PlusPageCancelSubscription() => PlusPageSuccess(
          hasPlus: false,
          monthlyPriceString: '4,99€',
          isSubscriptionManageable: true,
        ),
      _PlusStatusChanged(hasPlus: bool hasPlus) => PlusPageSuccess(
          hasPlus: hasPlus,
          monthlyPriceString: '4,99€',
          isSubscriptionManageable: true,
        ),
    };
    notifyListeners();
  }
}

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
    log('$products');

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
