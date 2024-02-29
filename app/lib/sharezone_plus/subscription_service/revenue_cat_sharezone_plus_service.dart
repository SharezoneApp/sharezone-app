// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:purchases_flutter/purchases_flutter.dart';

import 'purchase_service.dart';

class RevenueCatPurchaseService implements PurchaseService {
  @override
  Future<void> purchase(ProductId id) async {
    final offerings = await Purchases.getOfferings();
    final availablePackages = offerings
        .getOffering('default-dev-plus-subscription')!
        .availablePackages;
    final packageToPurchase = availablePackages
        .singleWhere((package) => package.offeringIdentifier == id.toString());
    await Purchases.purchasePackage(packageToPurchase);
  }
}
