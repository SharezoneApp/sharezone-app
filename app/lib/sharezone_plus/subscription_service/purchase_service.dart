// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_item.dart';

class ProductId extends Id {
  ProductId._(String id) : super(id, 'productId');

  /// 'donation_1_play_store' --> '1'
  factory ProductId.fromDonationItemId(SubscriptionItem id) {
    return ProductId._(id.toString().substring(9, 10));
  }
}

abstract class PurchaseService {
  Future<void> purchase(ProductId id);
  Future<List<StoreProduct>> getProducts();
}
