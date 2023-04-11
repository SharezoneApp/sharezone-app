// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class ProductId extends Id {
  ProductId(String id) : super(id, 'productId');
}

abstract class PurchaseService {
  Future<void> purchase(ProductId id);
  Future<List<StoreProduct>> getProducts();
}
