import 'package:common_domain_models/common_domain_models.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../donation_item.dart';

class ProductId extends Id {
  ProductId._(String id) : super(id, 'productId');

  /// 'donation_1_play_store' --> '1'
  factory ProductId.fromDonationItemId(DonationItemId id) {
    return ProductId._(id.toString().substring(9, 10));
  }
}

abstract class PurchaseService {
  Future<void> purchase(ProductId id);
  Future<List<Product>> getProducts();
}
